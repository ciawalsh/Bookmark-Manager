require_relative 'database'
require 'sinatra/base'
require 'rack-flash'
require 'mailgun'
# require 'sinatra/url_for'

class BookmarkManager < Sinatra::Base
	helpers UserSession
	helpers SendEmail
	# helpers Sinatra::UrlForHelper

	enable :sessions
	set :session_secret, 'super secret'
	use Rack::Flash
	use Rack::MethodOverride
	

	get '/' do
		@links = Link.all
	  erb :index
	end

	post '/links' do
		url =  params["url"] =~ /^http.?:\/\// ? params["url"] : "http://" + params["url"]
		title = params["title"]
		tags = params["tags"].split(" ").map do |tag|
			Tag.first_or_create(:text => tag)
		end
		Link.create(:url => url, :title => title, :tags => tags)
		redirect '/'
	end

	get '/tags/:text' do
		tag = Tag.first(:text => params[:text])
		@links = tag ? tag.links : []
		erb :index
	end

	get '/users/new' do
		@user = User.new
		erb :"users/new"
	end

	post '/users' do
		@user = User.create(:email => params[:email],
											 :password => params[:password],
											 :password_confirmation => params[:password_confirmation])
		if @user.save
			session[:user_id] = @user.id
			redirect '/'
		else
			flash.now[:errors] = @user.errors.full_messages
			erb :"users/new"
		end
	end

	get '/users/forgotten' do
		erb :"users/forgotten"
	end

	post '/users/forgotten' do
		User.password_reset(params[:email])
		user = User.first(:email => params[:email])
		message = user.password_token
		session[:email] = user.email 
		# link = url_for "/users/reset_password/#{message}", :full
		link = "127.0.0.1:9393/users/reset_password/#{message}"
		send_simple_message(params[:email], link)
		redirect '/'
	end

	get "/users/reset_password/:token" do
		erb :"users/new_password"
	end

	post '/users/reset_password' do
		user = User.first(:password_token => params[:token])
		user.update(:password => params[:password],
								:password_confirmation => params[:password_confirmation])
		user.password_token = nil
		user.save
		session[:user_id] = user.id
		redirect '/'
	end

	get '/sessions/new' do
		erb :"sessions/new"
	end

	post '/sessions' do
		email, password = params[:email], params[:password]
		user = User.authenticate(email, password)
		if user
			session[:user_id] = user.id
			redirect '/'
		else
			flash[:errors] = ["The email or password is incorrect"]
			erb :'sessions/new'
		end
	end

	delete '/sessions' do
		session[:user_id] = nil
		erb :"users/out"
	end

run! if app_file == $0
end
