require_relative 'modules/producer'
require_relative 'modules/instance_counter'

class Train
  include Producer
  include InstanceCounter

  attr_reader :carriage, :carriages, :speed, :type, :number
  attr_accessor :route

  NUMBER_FORMAT = /^[a-z\d]{3}(-[a-z\d]{2})?$/i.freeze

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    @type = type
    @carriage = 0
    @carriages = []
    @speed = 0
    validate!

    @@trains[number] = self
    register_instance
  end

  def increase_speed(speed)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def valid?
    validate!
  rescue StandardError
    false
    retry
  end

  def self.all
    @@trains
  end

  def add_carriage(carriage)
    raise 'Чтобы прицепить вагон поезд должен стоять!' unless @speed.zero?

    @carriages.push(carriage) if carriage.type == @type
  end

  def delete_carriage
    raise 'Чтобы отцепить вагон поезд должен стоять!' unless @speed.zero?
    raise 'В поезде нет вагонов' unless @carriages.any?

    @carriages.pop
  end

  def assign_route(route)
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
    @station_index -= 1 unless @station_index.zero?
  end

  def each_carriage
    @carriages.each { |carriage| yield(carriage) } if block_given?
  end

  private

  def station_through_index(index)
    @route.stations_list[index]
  end

  def validate!
    raise 'Вы не ввели номер поезда' if number.nil?
    raise 'В номере должно быть минимум 3 символа' if number.length < 3
    raise 'Неверный формат номера' if number !~ NUMBER_FORMAT

    true
  end
end
