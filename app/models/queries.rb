module Queries
  def self.get_all_badges(badge_type, user_name)
    Feedback.where("badge = ? AND recipient = ?", badge_type, user_name)
  end

  def self.add_all_quantities(collection)
    collection.map { |badge| badge.quantity }.reduce(:+)
  end

  def self.find_most_active(collection)
    total = 0
    most_active = collection.keep_if {| key, value | value >= total }
  end

  def self.find_all_participants
    collection = {}
    Feedback.all.each do |badge|
      if collection.has_key?(badge.sender)
        collection[sender] += 1
      else
        collection[sender] = 1
      end
    end
    collection
  end
end
