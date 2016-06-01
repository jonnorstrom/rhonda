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
                         badge: info_hash[:badge])
   if badge.save
     {
       "response_type": "in_channel",
       "attachments": [
          {
            "text": "_Thank you for your feedback!_ You gave <@U123|#{badge.recipient}> some #{badge.badge} #{badge.reason}",
            "mrkdwn_in": [
                "text",
            ]
          }
        ]
      }.to_json
   else
     {"attachments": [
          {
            "text": "_Something went wrong, try this format:_ [#] [badge] *to* @[person] *for* [reason]",
            "mrkdwn_in": [
                "text",
            ]
          }
        ]
      }
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
