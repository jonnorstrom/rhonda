module Queries
  ## gets all badges according to the three params - badge_type and user_name, and recipient/sender
  ## Queries.get_all_badges("stars", "trev", "recipient")
  def self.get_all_badges(badge_type, user_name, position)
    Feedback.where("badge = ? AND #{position} = ?", badge_type, user_name)
  end

  ## returns an integer that is the sum of the quantity field of a collection of badges
  ## Queries.add_all_quantities(Queries.get_all_badges("stars", "trev", "recipient"))
  def self.add_all_quantities(collection)
    collection.map { |badge| badge.quantity }.reduce(:+)
  end

  ## returns and array of hashes that include the username and how many Feedack object's they've created in the database. Pay no attention to parameters
  ## Queries.find_most_active(Queries.find_all_participants)
  def self.find_most_active(collection)
    total = 0
    most_active = []
    collection.each do | key, value |
      if value >= total
        total = value
        most_active.clear << {key => value}
      end
    end
    most_active
  end

  ## gathers a hash of all the participants and how many times they've created a Feedback object
  def self.find_all_participants
    collection = {}
    Feedback.all.each do |badge|
      if collection.has_key?(badge.sender)
        collection[badge.sender] += 1
      else
        collection[badge.sender] = 1
      end
    end
    collection
  end
end
