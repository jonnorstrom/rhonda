require_relative 'parser'
require_relative 'badge'

p badge = Badge.new(Parser.get_badge_data("3 stars to @dave for bringing coffee"))
