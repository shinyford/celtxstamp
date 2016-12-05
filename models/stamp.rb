require 'RMagick'
require 'base64'
require 'zlib'

class Stamp
	include DataMapper::Resource

	belongs_to :user

	property :id,			      Serial
	property :tl, 			    String
	property :tc, 			    String
	property :tr, 			    String
	property :bl, 			    String
	property :bc, 			    String
	property :br, 			    String
	property :filename, 	  String
	property :start_page, 	Integer
	property :timezone, 	  Integer
	property :numpages, 	  Integer
	property :beenread?, 	  Boolean, :default => false
	property :encconts, 	  Text

	INITVALUE = "%INIT%"

	def initialize(params = nil)
		if params
			Stamp.normalise(params)
			params[:start_page] = params[:start_page].to_i || 0
		else
			params = {:start_page => 0}
		end
		super(params)
	end

	def contents
	  @contents ||= Base64.decode64(encconts)
  end

	def stamped(nozip = false)
		@stamp ||= {}
		@stamp[nozip ? 1 : 2] ||= (add_stamp(contents, nozip) if contents)
	end

	def as_jpeg(page_id = 0, size = 33)
		if thumbnailed(page_id)
			pdf_pages = Magick::Image.from_blob(thumbnailed(page_id))
			pdf_page = pdf_pages[page_id < pdf_pages.size ? page_id : 0]
			pdf_page.resize!(size/100.0) unless size == 100
			pdf_page = pdf_page.normalize
			pdf_page.to_blob { self.format = 'jpg' }
		else
			"none"
		end
	end

	def selectively_update_attrs(facets)
		facets.each do |key, value|
		  self[key] = value if value != INITVALUE
		end
	end

	private

	STD_OFFSET = 10
	STAMP_FONT_SIZE = 10
	STAMP_FONT_WIDTH = 6
	PAGE_FLD = '%Page%'
	PAGES_FLD = '%Pages%'
	DATE_FLD = '%Date%'
	TIME_FLD = '%Time%'

	class << self

		def create_or_update(attrs, user)
			self.normalise(attrs)
			unless stamp = user.find_stamp(attrs[:filename])
				stamp = self.new
				stamp.user = user
			end
			stamp.selectively_update_attrs(attrs)
			stamp.save!
			stamp
		end

		def normalise(params)
		  if (pdf = params.delete("pdf"))
				text = pdf[:tempfile].read
				params["encconts"] = Base64.encode64(text)
				params["numpages"] = text.split(/\/Length\s+\d+\s+\/Filter\s+\/FlateDecode\s+>>\s+stream\s+/m).size - 2
				params["filename"] = pdf[:filename]
				params["beenread"] = false
			end
		end

	end

	def thumbnailed(page_id)
		@thumbnails ||= {}
		@thumbnails[page_id] ||= (create_thumb(contents, page_id) if contents)
	end

	def add_stamp(pdf, nozip = false)
		newpage = ''
		if pdf.match(/\/MediaBox\s+\[0\s+0\s+(\d+(\.\d+)?)\s+(\d+(\.\d+)?)\]/)
			width = $1.to_f
			height = $3.to_f
			pdf = characterise(pdf)
			pdf = unflate(pdf)
			portions = pdf.split(/\/Length\s+\d+\s+>>\s+stream\s+BT\s+/m)
			portions.each_with_index do |portion, idx|
				if portion.match(/^(.*)\s+ET(.*)/m)
					body = $2
					content = "BT #{create_stamp_elements(width, height, idx + startpage - 1)} #{denumber($1)} ET"
					if nozip
						newpage += "/Length #{content.size}\n>>\nstream\n#{content}#{body}"
					else
						content = Zlib::Deflate.deflate(content)
						newpage += "/Length #{content.size}\n/Filter /FlateDecode\n>>\nstream\n#{content}#{body}"
					end
				else
					newpage += portion
				end
			end
		end
		newpage
	end

	def create_thumb(pdf, page_id)
		if pdf.match(/\/MediaBox\s+\[0\s+0\s+(\d+(\.\d+)?)\s+(\d+(\.\d+)?)\]/)
			width = $1.to_f
			height = $3.to_f
			portions = pdf.split(/\s+>>\s+stream\s+/)
			portion = portions[page_id >= portions.size ? 0 : page_id + 1]
			if portion.match(/^(.*)(ends)?tream/m)
				content = Zlib::Inflate.inflate($1)
				if content.match(/^(.*)BT\s+(.*)\s+ET$/m)
					Thumbsample.create(width, height, "#{$1} BT #{create_stamp_elements(width, height, page_id)} #{denumber($2)} ET")
				end
			end
		end
	end

	def characterise(pdf)
		if pdf.match(/\/FirstChar\s+(\d+)\s/m)
			minchar = $1.to_i
			if pdf.match(/^(.*\sobj\s+\[)([\d\s]+)(\]\s+endobj.*$)/m)
				first_part = $1
				last_part = $3
				chars = Hash.new(0)
				$2.split(' ').each_with_index { |charwidth,idx| chars[minchar + idx] = charwidth.to_i }
				part_characterise(chars, tl)
				part_characterise(chars, tc)
				part_characterise(chars, tr)
				part_characterise(chars, bl)
				part_characterise(chars, bc)
				part_characterise(chars, br)
				unless chars.keys.length == 0
					minchar = [33, chars.keys.min].max
					maxchar = chars.keys.max
					pdf = first_part + ((minchar..maxchar).map { |i| chars[i] }.join(' ')) + last_part
					pdf.sub!(/\/FirstChar\s+(\d+)\s+\/LastChar\s+(\d+)\s/m, "/FirstChar #{minchar}\n/LastChar #{maxchar}\n")
				end
			end
		end
		pdf
	end

	def part_characterise(chars, str)
		(0...str.length).each { |i| chars[str[i].ord] = 600 } if str
	end

	def startpage
		@startpage ||= start_page || 0
	end

	def denumber(text)
		text.gsub(/Td *\[\(\d+\.\)\]TJ/, 'Td[()]TJ').gsub(/-\d+\(\d+\.\)\]TJ/, ']TJ')
	end

	def unflate(pdf)
		newpdf = []
		pdf.split(/endobj/m).each do |portion|
			if portion.match(/(^.*)\/Filter\s+\/FlateDecode\s+>>\s+stream\s+(.*$)/m)
				newpdf << "#{$1}\n>>\nstream\n#{Zlib::Inflate.inflate($2)}endstream\n"
			else
				newpdf << portion
			end
		end
		newpdf.join('endobj')
	end

	def create_stamp_elements(width, height, index)
		if index > 0
			@x = 0
			@y = 0
			"/F27 #{STAMP_FONT_SIZE} Tf " +
			left_stamp(index, width, STD_OFFSET, bl) +
			centre_stamp(index, width, STD_OFFSET, bc) +
			right_stamp(index, width, STD_OFFSET, br) +
			left_stamp(index, width, height-STD_OFFSET-STD_OFFSET, tl) +
			centre_stamp(index, width, height-STD_OFFSET-STD_OFFSET, tc) +
			right_stamp(index, width, height-STD_OFFSET-STD_OFFSET, tr) +
			"#{-@x} #{-@y} Td[()]TJ "
		end
	end

	def left_stamp(index, width, y, text)
		make_stamp(index, STD_OFFSET, y, text, 0)
	end

	def centre_stamp(index, width, y, text)
		make_stamp(index, width/2, y, text, STAMP_FONT_WIDTH/2)
	end

	def right_stamp(index, width, y, text)
		make_stamp(index, width-STD_OFFSET-STD_OFFSET, y, text, STAMP_FONT_WIDTH)
	end

	def make_stamp(index, x, y, text, scaler)
		return '' if text.blank? or index < 1

		text = parse_text(text, index)
		x -= scaler * text.length
		@x, @y, stamp = x, y, "#{x - @x} #{y - @y} Td[(#{enspace(text)})]TJ "

		stamp
	end

	def enspace(text)
		text.gsub('(', '\\(').gsub(')', '\\)').gsub(' ', ')-600(')
	end

	def parse_text(text, index)
		text.gsub(PAGE_FLD, index.to_s).gsub(PAGES_FLD, number_of_numbered_pages).gsub(DATE_FLD, upload_date).gsub(TIME_FLD, upload_time)
	end

	def upload_date
		@upload_date ||= upload_datetime.strftime('%d %b %Y')
	end

	def upload_time
		@upload_time ||= upload_datetime.strftime('%H:%M')
	end

	def upload_datetime
		@upload_datetime ||= DateTime.now.new_offset(Rational(-timezone, 24*60))
	end

	def number_of_numbered_pages
		(numpages - startpage).to_s
	end

end
