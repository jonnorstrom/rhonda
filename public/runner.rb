require_relative 'parser'
require_relative 'badge'

quant = /\A\d+,?\d*/.match(message_from_slack)
quant.times do
  badge = Badge.new(Parser.get_badge_data(message_from_slack))
end
