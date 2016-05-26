require 'sinatra'

get '/' do
 p 'hello world'
end

post '/badge' do
  p "hey - made it!"
end
