class CarriagePassenger < Carriage
  attr_accessor :number_places, :taken_places, :number

  def initialize(number_places, number)
    @type = :passenger
    @number_places = number_places
    @number = number
    @taken_places = 0
  end

  def take_place
    @taken_places += 1 if taken_places <= number_places
  end

  def occupied_places
    @taken_places
  end

  def free_places
    @number_places - @taken_places
  end
end
