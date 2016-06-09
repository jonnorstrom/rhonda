class Feedback < ActiveRecord::Base
  validates :recipient,
            :recipient_id,
            :sender,
            :sender_id,
            :team_domain,
            :team_id,
            :channel_name,
            :channel_id,
            :response_url,
            :text,
            :quantity,
            :badge,
            :reason,
            :schema_version,
  presence: true

  ## checks list of people on team to find the person mentioned, then adds their user ID to the database object
  def check_match(team_members)
    team_members.each do |member|
      if member["name"] == recipient
        self.recipient_id = member["id"]
      end
    end
  end

  def add_recipient_id
    ## formats the string, and makes the Net HTTP request
    response = Net::HTTP.get_response(Uri.make_string)
    user_response = JSON.parse(response.body)

    ## checks the response for all the members and finds the member that was named in the feedback
    ## then assigns the feedback.recipient_id to that users id from the API resopnse
    check_match(user_response["members"])
  end

  ## will send proper message back to slack
  def send_feedback_to_slack
    send_request_to_slack(make_positive_response)
  end

  ## will send proper error back to slack, likely because parser didn't pick up the right data.
  ## this should also help eliminate unwanted 500 errors
  def send_error_to_slack
    send_request_to_slack(make_error_response)
  end

  private

  ## this method is the one that actually sends the response back to slack
  def send_request_to_slack(response_body)
    uri = URI(response_url)
    req = Net::HTTP::Post.new(uri, {'Content-Type' =>'application/json'})

    req.body = response_body

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(req)
    end
  end

  def make_positive_response
    {
      "response_type": "in_channel",
      "attachments": [
         {
           "fallback": "#{sender} gave #{recipient} some feedback!",
           "text": "<@#{sender_id}> gave <@#{recipient_id}> some #{badge} #{reason}",
           "mrkdwn_in": [
               "text",
           ]
         }
       ]
     }.to_json
  end

  def make_error_response
    {
      "response_type": "ephemeral",
      "attachments": [
         {
           "fallback": "_Something went wrong, try this format:_ [#] [badge] *to* @[person] *for* [reason]",
           "text": "_Something went wrong, try this format:_ [#] [badge] *to* @[person] *for* [reason]",
           "mrkdwn_in": [
               "text",
           ]
         }
       ]
     }.to_json
  end
end
