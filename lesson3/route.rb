require_relative 'modules/instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations_list

  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
    register_instance
  end

  def add_station(station)
    raise "Станция #{station.name} уже есть в маршруте" if @stations_list.include?(station)
    @stations_list.insert(-2, station)
    puts "К маршруту добавлена станция #{station.name}"
  end

  def delete_middle_station(station)
    raise "Вы не можете удалить первую и последнюю станцию маршрута." if [stations_list.first, stations_list.last].include?(station)
      @stations_list.delete(station) 
      puts "Из маршрута удалена станция #{station.name}"
  end

  def show_stations
    @stations_list.each_with_index do |station, index|
      puts "#{index + 1}: #{station}"
    end
  end

  def name
    stations_list.first.name + "-" + stations_list.last.name
  end
end
