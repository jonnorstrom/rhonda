require 'sinatra'

get '/' do
  p ENV["SLACK_TOKEN"]
end

post '/badge' do

end
