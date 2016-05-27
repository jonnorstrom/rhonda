require 'sinatra'

get '/' do
 p "hello world"
end

post '/badge' do
  # made badge in database that I don't have set up yet
  p "MADE IT TO POST"
end
