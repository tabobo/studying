class CarriageCargo < Carriage
  attr_accessor :volume, :taken_volume, :number

  def initialize(volume, number)
    @type = :cargo
    @volume = volume
    @number = number
    @taken_volume = 0
  end

  def take_volume(amount_volume)
    @taken_volume += amount_volume if taken_volume <= volume
  end

  def occupied_volume
    @taken_volume
  end

  def free_volume
    @volume - @taken_volume
  end
end
