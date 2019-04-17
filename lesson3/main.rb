require_relative 'modules/producer'
require_relative 'modules/instance_counter'

require_relative './train'
require_relative './route'
require_relative './station'
require_relative './cargo_train'
require_relative './passenger_train'
require_relative './carriage'
require_relative './carriage_cargo'
require_relative './carriage_pass'

class Programm

  attr_accessor :stations, :trains, :routes

  def initialize
    @stations = []
    @routes = []
  end

  def programm_process
    loop do
      start_programm
    end
  end

  def start_programm
    puts "---------"
    puts "Здравствуйте, это программа Железная дорога. Что вы хотите сделать?"
    puts "Введите 1, если вы хотите создать станцию."
    puts "Введите 2, если вы хотите создать поезд."
    puts "Введите 3, если вы хотите создавать маршруты и управлять станциями в нем (добавлять, удалять)."
    puts "Введите 4, если вы хотите назначать маршрут поезду."
    puts "Введите 5, если вы хотите добавить вагоны к поезду."
    puts "Введите 6, если вы хотите отцепить вагоны от поезда."
    puts "Введите 7, если вы хотите перемещать поезд по маршруту вперед и назад."
    puts "Введите 8, если вы хотите просматривать список станций и список поездов на станции."
    puts "Введите 0, если вы хотите закончить программу."
    puts "---------"

    choice = gets.chomp.downcase
    case choice
    when "1"
      new_station
    when "2"
      new_train
    when "3"
      new_route
    when "4"
      set_route
    when "5"
      add_carriage
    when "6"
      delete_carriage
    when "7"
      move_train
    when "8"
      stations_and_trains
    when "0" || "стоп"
    exit
    else
    puts "Sorry, I didn't understand you."
    end
  end

  def new_station # создание новой станции
    puts "Введите название новой станции:"
    name = gets.chomp
    station = Station.new(name)
    @stations.push(station)
    puts "Создана станция #{name}"
  end

  def new_train # создание нового поезда
    puts "Введите тип поезда: PassengerTrain или CargoTrain"
    type = gets.chomp
    puts "Введите номер поезда"
    number = gets.chomp
    if type == "CargoTrain"
      CargoTrain.new(number)
      puts "Вы создали поезд. Номер: #{number}, тип: #{type}."
    elsif type == "PassengerTrain"
      PassengerTrain.new(number)
      puts "Вы создали поезд. Номер: #{number}, тип: #{type}."
    else
      puts "Такого типа поезда не существует."
    end
  end

  def new_route # Создавать маршруты и управлять станциями в нем (добавлять, удалять)
    puts "Чтобы создать маршрут, введите первую и последнюю станцию на нем."
    station_name1 = gets.chomp
    station_name2 = gets.chomp
    station1 = station_by_name(station_name1)
    station2 = station_by_name(station_name2)
    route = Route.new(station1, station2)
    @routes.push(route)
    puts "Был создан маршрут #{route.name}."

    puts "Введите add, чтобы добавить станцию на маршрут"
    puts "Введите delete, чтобы удалить станцию из маршрута"
    puts "Введите 0, чтобы перейти в главное меню"
    choice = gets.chomp
    
    if choice == "add"
      puts "Введите название станции"
      station_name = gets.chomp
      station = station_by_name(station_name)
      route.add_station(station)
    elsif choice == "delete"
      puts "Введите название станции"
      station = gets.chomp
      route.delete_middle_station(station)
    else 
      start_programm
    end
  end

  def set_route # Назначить маршрут поезду
    puts "Список существующих маршрутов:"
    @routes.each_with_index { |route, i| puts "#{i + 1}. #{route.name} "}

    puts "Чтобы назначить маршрут, введите номер поезда"
    train_number = gets.chomp
    train = Train.find(train_number)
    
    puts "Введите название маршрута"
    route_name = gets.chomp
    route = route_by_name(route_name)

    train.set_route(route)
    puts "Поезду #{train_number} был назначен маршрут #{route.name}."
  end

  def add_carriage # добавить вагоны к поезду
    puts "Введите номер поезда"
    train_number = gets.chomp
    train = Train.find(train_number)
    if train.type == :cargo
      carriage = CarriageCargo.new
      puts "Тип поезда: грузовой."
      train.add_carriage(carriage)
    elsif train.type == :passenger
      carriage = CarriagePassenger.new
      puts "Тип поезда: пассажирский."
      train.add_carriage(carriage)
    else
      puts "Поезд не найден"
    end
  end

  def delete_carriage # отцепить вагон
    puts "Введите номер поезда"
    train_number = gets.chomp
    train = Train.find(train_number)
    train.delete_carriage
  end

  def move_train # перемещать поезд по маршруту вперед и назад
    puts "Чтобы переместить поезд, введите номер поезда"
    train_number = gets.chomp
    train = Train.find(train_number)
    puts "Если хотите переместить поезд вперед, введите forward, если назад - back"
    choice = gets.chomp
    if choice == "forward"
      train.move_forward
      puts "Поезд переместился вперед на станцию #{train.current_station.name}"
    elsif choice == "back"
      train.move_back
      puts "Поезд переместился назад на станцию #{train.current_station.name}"
    else
      puts "Ошибка в наборе"
    end
  end

  def stations_and_trains # Просматривать список станций и список поездов на станции
    puts "Cписок станций:"
    @stations.each_with_index { |station, i| puts "#{i + 1}. #{station.name} "}
    puts "Введите название станции, чтобы просмотреть поезда на ней."
    station_name = gets.chomp
    station = station_by_name(station_name)
    puts "На станции #{station.name} находятся следующие поезда: "
    station.trains.each_with_index { |train, i| puts "#{i + 1}. #{train.number}" }
  end

  private # методы только для пользования внутри класса

  def station_by_name(station_name)
    @stations.find { |station| station.name == station_name }
  end

  def route_by_name(route_name)
    @routes.find { |route| route.name == route_name }
  end

end

programm = Programm.new
programm.programm_process
