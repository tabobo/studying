require_relative 'modules/instance_counter'

class Station
  include InstanceCounter

  attr_reader :trains, :name

  @stations = []

  class << self
    attr_accessor :stations

    def all
      @stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    self.class.stations << self
    register_instance
  end

  def train_in(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def each_train
    @trains.each { |train| yield(train) } if block_given?
  end

  def train_out(train)
    @trains.delete(train)
  end
end
