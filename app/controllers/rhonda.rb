get '/' do

end

post '/badge' do
  message_from_slack = params[:text]
  info_hash = Parser.get_feedback_data(message_from_slack)
  feedback = Feedback.new(recipient: info_hash[:recipient],
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
  if feedback.save
    feedback.send_feedback_to_slack
  else
    feedback.send_error_to_slack
  end
end
