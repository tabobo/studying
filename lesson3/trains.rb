require_relative './station'
require_relative './route'

class Train
  attr_reader :amount_carriages, :speed, :type, :train_number

  def initialize(train_number, type, amount_carriages = 0)
    @train_number = train_number
    @type = type
    @amount_carriages = amount_carriages
    @speed = 0
  end

  def increase_speed(speed)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_carriage
    @amount_carriages += 1 if @speed == 0
  end

  def delete_carriage
    @amount_carriages -= 1 if @speed == 0 && @amount_carriages > 0
  end

  def set_route(route)
    @route = route
    @station_index = 0
  end

  def move_forward
    @station_index += 1 if @route.stations_list.size - 1 > @station_index
  end

  def move_back
    @station_index -= 1 unless @station_index == 0
  end

  def current_station
    station_through_index(@station_index)
  end

  def previous_station
    station_through_index(@station_index - 1)
  end

  def next_station
    station_through_index(@station_index + 1)
  end

  def station_through_index(index)
    @route.stations_list[index]
  end
end
