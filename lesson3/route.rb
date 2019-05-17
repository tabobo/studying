require_relative 'modules/instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations_list

  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
    register_instance
  end

  def add_station(station)
    raise "Станция #{station.name} уже есть в маршруте" if stations_list.include?(station)

    stations_list.insert(-2, station)
  end

  def delete_middle_station(station)
    if [stations_list.first, stations_list.last].include?(station)
      raise 'Вы не можете удалить первую и последнюю станцию маршрута.'
    end

    stations_list.delete(station)
  end

  def name
    stations_list.first.name + '-' + stations_list.last.name
  end
end
