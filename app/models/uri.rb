module Uri
  def self.make_string
    uri = URI("https://slack.com/api/users.list?token=#{ENV["SLACK_USERS_TOKEN"]}&pretty=1")
  end
end
