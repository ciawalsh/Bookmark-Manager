require 'sinatra/base'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

# DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "postgres://localhost:15432/bookmark_manager_#{env}")

require './lib/link' # this needs to be done after datamapper is initialised
require './lib/tag'
require './lib/user'
require './helpers/user_application'

DataMapper.finalize
DataMapper.auto_upgrade!

class BookmarkManager < Sinatra::Base
	helpers UserSession

enable :sessions
set :session_secret, 'super secret'

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
	erb :"users/new"
end

post '/users' do
	user = User.create(:email => params[:email],
										 :password => params[:password])
	session[:user_id] = user.id
	redirect '/'
end

run! if app_file == $0
end
