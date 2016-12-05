#! /usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'common'

use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'stamp.gomes.com.es',
                           :path => '/',
                           :expire_after => 60*60, # In seconds
                           :secret => 'SilenceWillFall'


# new

before %r{^/(create|index)?$} do |add|
	puts "...> #{session['email']} #{session['password']}"
  @user = User.login(session["email"], session["password"])
  redirect to('/users/login') unless @user.logged_in?
end


get '/thumbs/:id' do |id|
	@stamp = Stamp.find(id.to_i)
  erb :thumbs
end

post '/thumbs' do
	user = User.first(:email => session["email"]) if session["email"]
	@stamp = Stamp.create_or_update(params["stamp"], user) if params["stamp"]
  erb :thumbs
end

get '/thumbs' do
	user = User.first(:email => session["email"]) if session["email"]
  erb :thumbs
end

get '/as_jpeg/:stamp_id/:page_id/:size.jpg' do |stamp_id, page_id, size|
  content_type 'image/jpeg'
	stamp = Stamp.get(stamp_id.to_i)
	puts "--> #{stamp.contents.length}"
	stamp.as_jpeg(page_id.to_i, size.to_i) if stamp
end

post '/users/login' do
  if params[:user]
		salt_if_creating = ((params[:commit] != 'Log in' and params[:user][:password] == params[:user][:qassword]) ? params[:user][:salt] : nil)
    @user = User.login(params[:user][:email], params[:user][:password], salt_if_creating)
    if @user.logged_in?
	    session["email"] = @user.email
	    session["password"] = @user.password
	    redirect to('/create')
    end
  else
    @user = User.create!(:email => session["email"])
  end
	erb :login
end

get '/users/login' do
	@user = User.new(:email => session["email"])
	erb :login
end

get '/users/salt' do
  User.find_salt_for(params[:email])
end

get '/index' do
  @users = User.find(:all)
  erb :index
end

get '/show/:id' do |id|
  @stamp = Stamp.get id.to_i
  erb :show
end

get %r{/(create)?} do
  @stamp = Stamp.new
  erb :create
end

post %r{/(create)?} do
  if params["stamp"]
    @stamp = Stamp.create_or_update(params["stamp"], @user)
    if stamp = @stamp.stamped(params["commit"] != "Create")
      if params["commit"] == "Create"
        content_type 'application/pdf'
				attachment @stamp.filename
      else
	    	content_type 'text/plain'
        stamp = '<pre>' + stamp + '</pre>'
      end
    else
    	content_type 'text/plain'
			stamp = 'Pdf unstampable'
    end
    stamp
  else
    @stamp = Stamp.new
	  erb :create
  end
end

