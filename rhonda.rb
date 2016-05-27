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
  {person: badge.person}.to_json
end

post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip

  action, repo = message.split('_').map {|c| c.strip.downcase }
  repo_url = "https://api.github.com/repos/#{repo}"

  case action
    when 'issues'
      resp = HTTParty.get(repo_url)
      resp = JSON.parse resp.body
      respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
  end
end

def respond_message message
  content_type :json
  {:text => message}.to_json
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
