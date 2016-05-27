require 'sinatra'

get '/' do
 p "hello world"
end

post '/badge' do
  # made badge in database that I don't have set up yet
  p Badge.new(Parser.get_badge_data(params[:text]))
end
