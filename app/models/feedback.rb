class Feedback < ActiveRecord::Base
  validates :recipient,
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
end
