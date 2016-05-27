require 'sinatra'
require_relative './public/badge'
require_relative './public/parser'


get '/' do
 p "hello world"
end

post '/badge' do
  # made badge in database that I don't have set up yet
  "YOOOO DUDE"
end



# badge = Badge.new(Parser.get_badge_data(params[:text]))
# if badge.note == "for being great"
#   {
#     "text": "You think #{badge.person} is pretty great",
#     "attachments": [
#       {
#         "text":"And you gave him a #{badge.type}"
#       }
#     ]
#   }
# else
#   "YOU FUCKED UP"
# end
