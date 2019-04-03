class Route
  attr_reader :stations_list

  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
  end

  def add_station(station)
    @stations_list.insert(-2, station)
  end

  def delete_middle_station(station)
    @stations_list.delete(station) if @stations_list.first != station && @stations_list.last != station
  end

  def show_stations
    @stations_list.each_with_index do |station, index|
      puts "#{index + 1}: #{station}"
    end
  end
end
