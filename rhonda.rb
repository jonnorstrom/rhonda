require 'sinatra'
require_relative './public/badge'
require_relative './public/parser'

get '/' do

end

post '/badge' do
  # made badge in database that I don't have set up yet
  message_from_slack = params[:text]
  p "--token--#{params[:token]}"
  p "--team_domain--#{params[:team_domain]}"
  p "--channel_name--#{params[:channel_name]}"
  p "--user_name--#{params[:user_name]}"
  badge = Badge.new(Parser.get_badge_data(message_from_slack))
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
