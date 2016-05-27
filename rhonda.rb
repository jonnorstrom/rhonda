require 'sinatra'
require_relative './public/badge'
require_relative './public/parser'
require 'json'

get '/' do
 p "hello world"
end

post '/badge' do
  # made badge in database that I don't have set up yet
  message_from_slack = params[:text]
  badge = Badge.new(Parser.get_badge_data(message_from_slack))
  # content_type :json
  # {text: "You think #{badge.person} is pretty great"}.to_json
  "Thank you for your feedback! You gave #{badge.person} some #{badge.type} #{badge.note}"
end

# POTENTIAL IDEAL WORK FLOW
###########################################################
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
###########################################################
