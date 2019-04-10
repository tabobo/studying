require_relative './trains'
require_relative './carriage'

class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end
end