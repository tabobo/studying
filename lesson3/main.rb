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

  @@carriage_cargo_index = 0
  @@carriage_pass_index = 0

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
    puts "Введите 3, если вы хотите создать маршрут."
    puts "Введите 9, если вы хотите выбрать маршрут и управлять станциями на нем (добавлять, удалять)."
    puts "Введите 4, если вы хотите назначать маршрут поезду."
    puts "Введите 5, если вы хотите добавить вагоны к поезду."
    puts "Введите 6, если вы хотите отцепить вагоны от поезда."
    puts "Введите 7, если вы хотите перемещать поезд по маршруту вперед и назад."
    puts "Введите 8, если вы хотите просматривать список станций и список поездов на станции."
    puts "Введите 8-1, если вы хотите занять место в пассажирском вагоне или загрузить грузовой вагон."
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
    when "9"
      manage_route
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
    when "8-1"
      take_place_carriage
    when "0" || "стоп"
    exit
    else
    puts "Sorry, I didn't understand you."
    end
  end

  def new_station # создание новой станции
    puts "Введите название новой станции:"
    name = gets.chomp
    new_station = station_by_name(name)
    raise "Вы не ввели название станции" if name == nil or name.size == 0 
    raise "Станция #{name} уже существует" if @stations.include?(new_station)
    station = Station.new(name)
    @stations.push(station)
    puts "Создана станция #{name}"
    rescue StandardError => e
    error_message e
    retry
  end

  def new_train # создание нового поезда
    puts "Введите номер поезда (латинские буквы или цифры в формате ххххх или ххх-хх)"
    number = gets.chomp
    raise "Поезд с таким номером уже существует" unless Train.find(number).nil?
    puts "Введите тип поезда: PassengerTrain или CargoTrain"
    type = gets.chomp
    if type == "CargoTrain"
      CargoTrain.new(number)
      puts "Вы создали поезд. Номер: #{number}, тип: #{type}."
    elsif type == "PassengerTrain"
      PassengerTrain.new(number)
      puts "Вы создали поезд. Номер: #{number}, тип: #{type}."
    else
      puts "Такого типа поезда не существует."
    end
  rescue StandardError => e
    error_message e
    retry
  end

  def new_route # Создавать маршруты и управлять станциями в нем (добавлять, удалять)
    raise "Для создания маршрута необходимо создать минимум 2 станции." if @stations.size == 0
    puts "Cписок станций:"
    @stations.each_with_index { |station, i| puts "#{i + 1}. #{station.name} "}
    puts "Чтобы создать маршрут, введите первую и последнюю станцию на нем."
    station_name1 = gets.chomp
    station_name2 = gets.chomp
    station1 = station_by_name(station_name1)
    station2 = station_by_name(station_name2)
    raise "Станции #{station_name1} не существует" unless @stations.include?(station1)
    raise "Станции #{station_name2} не существует" unless @stations.include?(station2)
    raise "Вы не ввели названия станций" if station_name1.size == 0 || station_name2.size == 0
    raise "Невозможно создать маршрут. Первая и последняя станция должны быть разными." if station_name1 == station_name2
    route = Route.new(station1, station2)
    @routes.push(route)
    puts "Был создан маршрут #{route.name}."
  rescue StandardError => e
    error_message e
  end

  def manage_route # Выбрать маршрут и управлять станциями на нем (добавлять, удалять)
    raise "Вы не создали ни одного маршрута" if @routes.size == 0
    puts "Список существующих маршрутов:"
    @routes.each_with_index { |route, i| puts "#{i + 1}. #{route.name} "}
    puts "Введите название маршрута, чтобы управлять им."
    route_name = gets.chomp
    route_edit = route_by_name(route_name)
    raise "Маршрут #{route_name} не найден" unless @routes.include?(route_edit)
    puts "Введите add, чтобы добавить станцию на маршрут"
    puts "Введите delete, чтобы удалить станцию из маршрута"
    choice = gets.chomp
    if choice == "add"
      puts "Введите название станции, которую вы хотите добавить"
      station_name = gets.chomp
      station = station_by_name(station_name)
      raise "Станции #{station_name} не существует" unless @stations.include?(station)
      raise "Вы не ввели названия станций" if station_name.size == 0
      route_edit.add_station(station)
      puts "К маршруту добавлена станция #{station.name}."
    elsif choice == "delete"
      puts "Введите название станции, которую вы хотите удалить"
      station_name = gets.chomp
      station = station_by_name(station_name)
      route_edit.delete_middle_station(station)
      puts "Из маршрута удалена станция #{station.name}."
    else 
      start_programm
    end

  rescue StandardError => e
    error_message e
  end

  def set_route # Назначить маршрут поезду
    raise "Вы не создали ни одного маршрута" if @routes.size == 0
    raise "Вы не создали ни одного поезда" if Train.all.empty?
    puts "Список существующих маршрутов:"
    @routes.each_with_index { |route, i| puts "#{i + 1}. #{route.name} "}

    puts "Чтобы назначить маршрут, введите номер поезда"
    train_number = gets.chomp
    raise "Поезда с таким номером не существует" if Train.find(train_number).nil?
    train = Train.find(train_number)
    
    puts "Введите название маршрута"
    route_name = gets.chomp
    route = route_by_name(route_name)
    raise "Маршрут #{route_name} не найден" unless @routes.include?(route)

    train.set_route(route)
    puts "Поезду #{train_number} был назначен маршрут #{route.name}."

  rescue StandardError => e
    error_message e
  end

  def add_carriage # добавить вагоны к поезду
    raise "Вы не создали ни одного поезда" if Train.all.empty?
    puts "Введите номер поезда"
    train_number = gets.chomp
    raise "Поезда с таким номером не существует" if Train.find(train_number).nil?
    train = Train.find(train_number)
    if train.type == :cargo
      puts "Введите объем вагона"
      volume = gets.to_i
      carriage = CarriageCargo.new(volume, @@carriage_cargo_index += 1)
      train.add_carriage(carriage)
      puts "Вагон прицеплен к поезду #{train_number}. Объем вагона: #{volume}. Тип поезда: грузовой. Количество вагонов: #{train.carriages.size}."
    elsif train.type == :passenger
      puts "Введите количество мест"
      number_places = gets.to_i
      carriage = CarriagePassenger.new(number_places, @@carriage_pass_index += 1)
      train.add_carriage(carriage)
      puts "Вагон прицеплен к поезду #{train_number}. Количество мест в вагоне: #{number_places}. Тип поезда: пассажирский. Количество вагонов: #{train.carriages.size}."
    else
      puts "Поезд не найден"
    end

  rescue StandardError => e
    error_message e
  end

  def delete_carriage # отцепить вагон
    raise "Вы не создали ни одного поезда" if Train.all.empty?
    puts "Введите номер поезда"
    train_number = gets.chomp
    raise "Поезда с таким номером не существует" if Train.find(train_number).nil?
    train = Train.find(train_number)
    train.delete_carriage
    puts "Вагон отцеплен от поезда #{train_number}. Количество вагонов: #{train.carriages.size}."

  rescue StandardError => e
    error_message e
  end

  def move_train # перемещать поезд по маршруту вперед и назад
    raise "Вы не создали ни одного поезда" if Train.all.empty?
    puts "Чтобы переместить поезд, введите номер поезда"
    train_number = gets.chomp
    raise "Поезда с таким номером не существует" if Train.find(train_number).nil?
    train = Train.find(train_number)
    raise "Поезду не назначен ни один маршрут" if train.route.nil?
    puts "Если хотите переместить поезд вперед, введите forward, если назад - back"
    choice = gets.chomp
    if choice == "forward"
      raise "Поезд уже находится на конечной станции." if train.current_station == train.route.stations_list.last
      train.move_forward
      puts "Поезд переместился вперед на станцию #{train.current_station.name}"
    elsif choice == "back"
      raise "Поезд уже находится на начальной станции." if train.current_station == train.route.stations_list.first
      train.move_back
      puts "Поезд переместился назад на станцию #{train.current_station.name}"
    else
      puts "Ошибка в наборе"
    end

  rescue StandardError => e
    error_message e
  end

  def stations_and_trains # Просматривать список станций и список поездов на станции
    raise "Вы не создали ни одной станции" if @stations.size == 0
    puts "Cписок станций:"
    @stations.each_with_index { |station, i| puts "#{i + 1}. #{station.name} "}
    puts "Введите название станции, чтобы просмотреть поезда на ней."
    station_name = gets.chomp
    station = station_by_name(station_name)
    raise "Станции #{station_name} не существует" unless @stations.include?(station)
    puts "На станции #{station.name} находятся следующие поезда: " 
    station.each_train do |train|
    puts "#{train.number}. Тип #{train.type}. Количество вагонов: #{train.carriages.size}."
    end
    
  rescue StandardError => e
    error_message e
  end

  def take_place_carriage # Занять место в вагоне
    raise "Вы не создали ни одного поезда" if Train.all.empty?
    puts "Введите номер поезда"
    train_number = gets.chomp
    raise "Поезда с таким номером не существует" if Train.find(train_number).nil?
    train = Train.find(train_number)
    raise "В поезде #{train_number} нет вагонов." if train.carriages.size == 0
    if train.type == :cargo
      puts "Список вагонов в грузовом поезде #{train_number}:"
      train.each_carriage do |carriage|
        puts "Вагон №#{carriage.number}. Количество свободного объема: #{carriage.free_volume}. Количество занятого объема: #{carriage.occupied_volume}"
      end
      puts "Введите номер вагона, который вы хотите загрузить"
      carriage_index = gets.to_i 
      carriage = train.carriages[carriage_index - 1]
      raise "Вагона с номером #{carriage_index} не существует." if carriage_index > train.carriages.size
      raise "В вагоне #{carriage_index} нет свободного места." if carriage.free_volume == 0
      puts "Введите количество объема, который вы хотите загрузить в вагон."
      amount_volume = gets.to_i
      raise "Недостаточно объема вагона. Доступный объем: #{carriage.free_volume}." if amount_volume > carriage.free_volume
      carriage.take_volume(amount_volume)
      puts "Вы заняли #{amount_volume} единицы объема в вагоне #{carriage_index}."
    elsif train.type == :passenger
      puts "Список вагонов в пассажирском поезде #{train_number}:"
      train.each_carriage do |carriage|
        puts "Вагон №#{carriage.number}. Количество свободных мест: #{carriage.free_places}. Количество занятых мест: #{carriage.taken_places}"
      end
      puts "Введите номер вагона, где вы хотите занять место"
      carriage_index = gets.to_i 
      raise "Вагона с номером #{carriage_index} не существует." if carriage_index > train.carriages.size
      carriage = train.carriages[carriage_index - 1]
      raise "В вагоне #{carriage_index} нет мест." if carriage.free_places == 0
      carriage.take_place
      puts "Вы заняли одно место в вагоне #{carriage_index}."
    else
      puts "Поезд не найден"
    end

  rescue StandardError => e
    error_message e
  end

  def error_message(e)
    puts "Ошибка: #{e.message}"
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
