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
  uri = URI("https://slack.com/api/users.list?token=#{ENV["SLACK_USERS_TOKEN"]}&pretty=1")
  response = Net::HTTP.get_response(uri)
  user_response = JSON.parse(response.body)
  p badge.recipient
  user_response["members"].each do |member|
    p member["name"]
    if member["name"] == badge.recipient
      badge.recipient_id = member[:id]
      p "HEY THEY MATCH"
    end
  end

  if badge.save
   uri = URI(badge.response_url)
   req = Net::HTTP::Post.new(uri, {'Content-Type' =>'application/json'})
   req.body = {
     "response_type": "ephemeral",
     "attachments": [
        {
          "text": "_Thank you for your feedback!_ You gave #{badge.recipient} some #{badge.badge} #{badge.reason}",
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
