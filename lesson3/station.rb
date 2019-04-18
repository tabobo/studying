require_relative 'modules/instance_counter'

class Station
  include InstanceCounter

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @@stations.push(self)
    @name = name
    @trains = []
    register_instance
  end

  def train_in(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def train_out(train)
    @trains.delete(train)
  end
end
