require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

def nil.blank?
	true
end

class String
	def blank?
		self == ''
	end
end

# fix required for bug with DataMapper 1.1.0 and Ruby 1.8.6
module Enumerable
  unless instance_methods.include?("first")
    def first(num = nil)
      if num == nil
        holder = nil
        catch(:got_element) do
          each do |e|
            holder = e
            throw(:got_element)
          end
        end
        holder
      else
        holder = []
        catch(:got_elements) do
          each do |e|
            holder << e
            throw(:got_element) if num == 0
            num -= 1
          end
        end
        holder
      end
    end
  end
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db_celtxstamp.sqlite3")
require './models/stamp'
require './models/user'
require './models/thumbsample'
DataMapper.auto_upgrade!
