require_relative './trains'

class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def train_in(train)
    @train = train
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def train_out(train)
    @trains.delete(train)
  end
end
