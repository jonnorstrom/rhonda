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

  # Remember to create a migration!
  def check_match(team_members)
    team_members.each do |member|
      if member["name"] == self.recipient
        self.recipient_id = member["id"]
      end
    end
  end

end
