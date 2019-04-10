require_relative './trains'
require_relative './carriage'

class PassengerTrain < Train
  def initialize(number)
    super
    @type = :passenger
  end
end