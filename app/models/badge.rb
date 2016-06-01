class Badge
  attr_reader :quantity, :type, :person, :note

  def initialize(hash)
    @type = hash[:type]
    @person = hash[:person]
    @note = hash[:note]
  end
end
