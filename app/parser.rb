require_relative 'badge'

module Parser
  RGX = /(?<quantity>\A\d+,?\d*) (?<badge>.+(?= to @)) to (?<recipient>@\S+) (?<note>.+)$/
  def self.get_badge_data(message)
    match_data = RGX.match(message)

    { quantity: match_data[:quantity], person: match_data[:recipient], note: match_data[:note], type: match_data[:badge] }
  end
end

# private
#
# attr_accessor :recipient_index, :quantity_index
# attr_reader :message
#   def self.find_recipient # outputs an array of all the recipients
#     message.split(' ').select do |word|
#       if /@\S+/.match(word)
#         return word
#       else
#         @recipient_index += 1
#       end
#     end
#   end
#
#   def self.find_quantity # outputs the quantity of the badge(s) given as a string
#     message.split(' ').select do |word|
#       if /\A\d+/.match(word)
#         word ## equals the right number
#         return word
#       else
#         quantity_index += 1
#       end
#     end
#   end
#
#   def self.format_quantity # take find_quantity and converts the array of a single string into an integer
#     find_quantity.to_i
#   end
#
#   def self.find_note # must be called AFTER find_recipient method!!
#     message.split(' ')[(recipient_index+1)..-1].join(' ')
#   end
#
#   def self.find_badge # must be called AFTER find_quantity and after find_recipient methods
#     message.split(' ')[(quantity_index+1)...(recipient_index-1)].join(' ')
#   end
