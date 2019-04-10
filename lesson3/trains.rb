require_relative './station'
require_relative './route'
require_relative './carriage'

class Train
  attr_reader :carriage, :carriages, :speed, :type, :number
  def initialize(number)
    @number = number
    @type = type
    @carriage = 0
    @carriages = []
    @speed = 0
  end

  def increase_speed(speed)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    puts "Чтобы прицепить вагон, поезд должен стоять!" if @speed != 0
    if carriage.type == @type
      @carriages.push(carriage)
      puts "Вагон прицеплен. Количество вагонов в поезде #{number}: #{@carriages.size}."
    else 
      puts "Тип поезда и вагона не совпадают!"
    end
  end

  def delete_carriage
    puts "Чтобы отцепить вагон поезд должен стоять!" if @speed != 0
    if @carriages.size > 0
      @carriages.pop 
      puts "Вагон отцеплен. Количество вагонов в поезде #{number}: #{@carriages.size}."
    else 
      puts "Тип поезда и вагона не совпадают!"
    end
  end

  def set_route(route)
    @route = route
    @station_index = 0
    route.stations_list.first.train_in self
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

  def move_forward
    current_station.train_out self
    next_station.train_in self
    @station_index += 1 if @route.stations_list.size - 1 > @station_index
  end

  def move_back
    current_station.train_out self
    previous_station.train_in self
    @station_index -= 1 unless @station_index == 0
  end

  private # метод используется только внутри класса

  def station_through_index(index)
    @route.stations_list[index]
  end
end
