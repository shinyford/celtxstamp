#! /usr/bin/env ruby

require './common'

Stamp.all.each do |stamp|
  unless stamp.beenread? or stamp.encconts.nil?
    unless stamp.filename.blank?
      filename = stamp.filename.split('.')[0] + '.pdf'
    else
      filename = stamp.id.to_s + 'pdf'
    end
    puts "Doing #{filename}..."
    File.open(filename, 'w') {|f| f.write(stamp.stamped) } 
    stamp.beenread = true
    stamp.save
  end
end

