# require ::File.expand_path('../../config/environment',  __FILE__)
require_relative './config/environment'
require 'dotenv'

set :app_file, __FILE__

Dotenv.load

run Sinatra::Application
