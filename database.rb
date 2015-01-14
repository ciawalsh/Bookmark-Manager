require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

# DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "postgres://localhost:15432/bookmark_manager_#{env}")

require './lib/link' # this needs to be done after datamapper is initialised
require './lib/tag'
require './lib/user'
require './helpers/user_application'

DataMapper.finalize # this needs to be done after the required files.
DataMapper.auto_upgrade! # this needs to be done to create the models/'classes' within the database.