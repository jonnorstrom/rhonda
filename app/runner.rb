require_relative 'parser'
require_relative 'badge'

badge = Badge.new(Parser.get_badge_data(message_from_slack))
