class User
	include DataMapper::Resource

	has n, :stamps

	property :id,			Serial
	property :email, 		String
	property :password, 	String
	property :salt,	 		Integer

	class << self

		def login(email, password, salt = nil)
			if email.blank? or password.blank?
				create_user_error 'You must supply an email address and password'
			else
				@user = self.first(:email => email)
				if salt
					if @user
						if @user.password
							create_user_error("Email '#{email}' already exists", email) unless password == @user.password
						else
							@user.password = password
							@user.save
						end
					else
						@user = self.create!(:email => email, :password => password, :salt => salt)
					end
				else
					create_user_error('No such email and/or password', email) unless @user and @user.password == password
				end
			end
			@user
		end

		def find_salt_for(email)
			user = self.create!(:email => email, :salt => rand(9999999)) unless user = self.first(:email => email)
			user.salt
		end

		def purge
			User.all('password IS NULL AND created_at < TIMESTAMPADD(DAY, -7, NOW())').destroy
		end

		private

		def create_user_error(m, e = '')
			@user = self.new(:email => e)
			@user.errors.add(:error, m)
		end

	end

	def find_stamp(filename)
	  puts ">>> Looking for #{filename}"
		s = stamps.select { |s| s.filename == filename }.first
		puts ">>> Found: #{s.filename}" if s
		s
	end

	def logged_in?
		self.errors.size == 0 && !self.password.blank?
	end

end
