get '/' do

end

post '/badge' do
  message_from_slack = params[:text]
  info_hash = Parser.get_badge_data(message_from_slack)
  badge = Feedback.new(recipient: info_hash[:recipient],
                       sender: params[:user_name],
                       sender_id: params[:user_id],
                       team_domain: params[:team_domain],
                       team_id: params[:team_id],
                       channel_name: params[:channel_name],
                       channel_id: params[:channel_id],
                       response_url: params[:response_url],
                       text: params[:text],
                       quantity: info_hash[:quantity],
                       reason: info_hash[:reason],
                       badge: info_hash[:badge],
                       schema_version: 1.1)
  ## formats the string, and makes the Net HTTP request
  response = Net::HTTP.get_response(Uri.make_string)
  user_response = JSON.parse(response.body)

  ## checks the response for all the members and finds the member that was named in the badge
  ## then assigns the badge.recipient_id to that users id from the API resopnse
  badge.check_match(user_response["members"])

  if badge.save
   uri = URI(badge.response_url)
   req = Net::HTTP::Post.new(uri, {'Content-Type' =>'application/json'})
   req.body = {
     "response_type": "in-channel",
     "attachments": [
        {
          "text": "_Thank you for your feedback!_ You gave <@#{badge.recipient_id}> some #{badge.badge} #{badge.reason}",
          "mrkdwn_in": [
              "text",
          ]
        }
      ]
    }.to_json
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(req)
    end
  else
   uri = URI(badge.response_url)
   req = Net::HTTP::Post.new(uri, {'Content-Type' =>'application/json'})
   req.body = {
     "response_type": "ephemeral",
     "attachments": [
        {
          "text": "_Something went wrong, try this format:_ [#] [badge] *to* @[person] *for* [reason]",
          "mrkdwn_in": [
              "text",
          ]
        }
      ]
    }.to_json
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(req)
    end
  end
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
