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

class Main
  class WrongInput < StandardError; end
  class NoInput < StandardError; end
  class NoData < StandardError; end

  attr_accessor :stations, :trains, :routes

  MIN_AMOUNT_STATIONS = 3

  def initialize
    @stations = []
    @routes = []
    @carriage_cargo_index = 0
    @carriage_pass_index = 0
  end

  def program_process
    loop do
      show_menu

      begin
        choice = gets.chomp.downcase
        break if choice.nil?

        user_action(choice)
      rescue StandardError => e
        print_error_message e.message
      end
    end
  end

  def show_menu # rubocop:disable Metrics/MethodLength
    puts '---------'
    puts 'Здравствуйте, это программа Железная дорога. Что вы хотите сделать?'
    puts 'Введите 1, если вы хотите создать станцию.'
    puts 'Введите 2, если вы хотите создать поезд.'
    puts 'Введите 3, если вы хотите создать маршрут.'
    puts 'Введите 9, если вы хотите выбрать маршрут '\
         'и управлять станциями на нем (добавлять, удалять).'
    puts 'Введите 4, если вы хотите назначать маршрут поезду.'
    puts 'Введите 5, если вы хотите добавить вагоны к поезду.'
    puts 'Введите 6, если вы хотите отцепить вагоны от поезда.'
    puts 'Введите 7, если вы хотите перемещать поезд по маршруту.'
    puts 'Введите 8, если вы хотите просматривать список станций '\
         'и список поездов на станции.'
    puts 'Введите 8-1, если вы хотите занять место в пассажирском вагоне '\
         'или загрузить грузовой вагон.'
    puts 'Введите 0, если вы хотите закончить программу.'
    puts '---------'
  end

  def user_action(choice) # rubocop:disable Metrics/MethodLength
    case choice
    when '1' then new_station
    when '2' then new_train
    when '3' then new_route
    when '9' then manage_route
    when '4' then assign_route
    when '5' then add_carriage
    when '6' then delete_carriage
    when '7' then move_train
    when '8' then stations_and_trains
    when '8-1' then take_place_carriage
    when '0' || 'стоп' then exit
    else puts "Sorry, I didn't understand you."
    end
  end

  def new_station
    name = ask_new_station_name
    station = Station.new(name)
    @stations.push(station)
    puts "Создана станция #{name}"
  end

  def new_train
    number = ask_new_train_number
    type = choose_train_type
    Object.const_get(type).new(number)
    puts "Вы создали поезд. Номер: #{number}, тип: #{type}."
  end

  def new_route
    show_stations
    puts 'Чтобы создать маршрут, нужно назвать первую и последнюю станции на нем.'
    station_name1 = ask_station_name
    station_name2 = ask_station_name
    station1 = station_by_name(station_name1)
    station2 = station_by_name(station_name2)
    raise 'Первая и последняя станция должны быть разными.' if station_name1 == station_name2

    route = Route.new(station1, station2)
    @routes.push(route)
    puts "Был создан маршрут #{route.name}."
  rescue StandardError => e
    print_error_message e.message
  end

  def manage_route
    show_routes
    route_edit = ask_route
    puts '1 - Добавить станцию; 2 - Удалить станцию'
    choice = gets.to_i
    if choice == 1
      raise 'Недостаточно станций для добавления' if @stations.size < MIN_AMOUNT_STATIONS

      station_name = ask_station_name
      station = station_by_name(station_name)
      route_edit.add_station(station)
      puts "К маршруту добавлена станция #{station.name}."
    elsif choice == 2
      raise 'Недостаточно станций для удаления' if route_edit.stations_list.size < MIN_AMOUNT_STATIONS

      station_name = ask_station_name
      station = station_by_name(station_name)
      route_edit.delete_middle_station(station)
      puts "Из маршрута удалена станция #{station.name}."
    else
      program_process
    end
  rescue StandardError => e
    print_error_message e.message
  end

  def assign_route
    show_routes
    number = ask_exist_train_number
    train = Train.find(number)
    route_name = ask_route_name
    route = route_by_name(route_name)
    raise "Маршрут #{route_name} не найден" unless @routes.include?(route)

    train.assign_route(route)
    puts "Поезду #{number} был назначен маршрут #{route.name}."
  rescue StandardError => e
    print_error_message e.message
  end

  def add_carriage
    train_number = ask_exist_train_number
    train = Train.find(train_number)
    if train.type == :cargo
      puts 'Введите объем вагона'
      volume = gets.to_i
      carriage = CarriageCargo.new(volume, @carriage_cargo_index += 1)
      train.add_carriage(carriage)
      puts "Вагон прицеплен к поезду #{train_number}. " \
           "Объем вагона: #{volume}. Тип поезда: грузовой. " \
           "Количество вагонов: #{train.carriages.size}."
    elsif train.type == :passenger
      puts 'Введите количество мест'
      number_places = gets.to_i
      carriage = CarriagePassenger.new(number_places, @carriage_pass_index += 1)
      train.add_carriage(carriage)
      puts "Вагон прицеплен к поезду #{train_number}. " \
           "Количество мест в вагоне: #{number_places}. " \
           "Тип поезда: пассажирский. Количество вагонов: #{train.carriages.size}."
    else
      puts 'Поезд не найден'
    end
  end

  def delete_carriage
    train_number = ask_exist_train_number
    train = Train.find(train_number)
    train.delete_carriage
    puts "Вагон отцеплен от поезда #{train_number}. Количество вагонов: #{train.carriages.size}."
  end

  def move_train
    train_number = ask_exist_train_number
    train = Train.find(train_number)
    raise 'Поезду не назначен ни один маршрут' if train.route.nil?

    puts 'Если хотите переместить поезд вперед, введите forward, если назад - back'
    choice = gets.chomp
    if choice == 'forward'
      if train.current_station == train.route.stations_list.last
        raise 'Поезд уже находится на конечной станции.'
      end

      train.move_forward
      puts "Поезд переместился вперед на станцию #{train.current_station.name}"
    elsif choice == 'back'
      if train.current_station == train.route.stations_list.first
        raise 'Поезд уже находится на начальной станции.'
      end

      train.move_back
      puts "Поезд переместился назад на станцию #{train.current_station.name}."
    else
      puts 'Ошибка в наборе'
    end
  rescue StandardError => e
    print_error_message e.message
  end

  # show stations and trains on stations
  def stations_and_trains
    raise 'Вы не создали ни одной станции' if @stations.empty?

    puts 'Cписок станций:'
    @stations.each_with_index { |station, i| puts "#{i + 1}. #{station.name} " }
    puts 'Введите название станции, чтобы просмотреть поезда на ней.'
    station_name = gets.chomp
    station = station_by_name(station_name)
    raise "Станции #{station_name} не существует" unless @stations.include?(station)

    puts "На станции #{station.name} находятся следующие поезда: "
    station.each_train do |train|
      puts "#{train.number}. Тип #{train.type}. Количество вагонов: #{train.carriages.size}."
    end
  rescue StandardError => e
    print_error_message e.message
  end

  def take_place_carriage
    train_number = ask_exist_train_number
    train = Train.find(train_number)
    raise "В поезде #{train_number} нет вагонов." if train.carriages.empty?

    if train.type == :cargo
      show_list_cargo_carriages(train, train_number)
      puts 'Введите номер вагона, который вы хотите загрузить'
      carriage_index = gets.to_i
      carriage = train.carriages[carriage_index - 1]
      raise "Вагона № #{carriage_index} не существует." if carriage_index > train.carriages.size
      raise "В вагоне #{carriage_index} нет свободного места." if carriage.free_volume.zero?

      puts 'Введите количество объема, который вы хотите загрузить в вагон.'
      amount_volume = gets.to_i
      if amount_volume > carriage.free_volume
        raise "Недостаточно объема вагона. Доступный объем: #{carriage.free_volume}."
      end

      carriage.take_volume(amount_volume)
      puts "Вы заняли #{amount_volume} единицы объема в вагоне #{carriage_index}."
    elsif train.type == :passenger
      show_list_pass_carriages(train, train_number)
      puts 'Введите номер вагона, где вы хотите занять место'
      carriage_index = gets.to_i
      raise "Вагона с номером #{carriage_index} не существует." if carriage_index > train.carriages.size

      carriage = train.carriages[carriage_index - 1]
      raise "В вагоне #{carriage_index} нет мест." if carriage.free_places.zero?

      carriage.take_place
      puts "Вы заняли одно место в вагоне #{carriage_index}."
    else
      puts 'Поезд не найден'
    end
  rescue StandardError => e
    print_error_message e.message
  end

  private

  def ask_route_name
    puts 'Введите название нужного маршрута.'
    route_name = gets.chomp
    # route_edit = route_by_name(route_name)
    # raise "Маршрут #{route_name} не найден" unless @routes.include?(route_edit)
  end

  def ask_route
    puts 'Введите название нужного маршрута.'
    route_name = gets.chomp
    route = route_by_name(route_name)
    raise "Маршрут #{route_name} не найден" unless @routes.include?(route)

    route
  end

  def ask_new_station_name
    puts 'Введите название новой станции'
    name = gets.chomp
    raise 'Вы не ввели названия станций' if name.empty?
    raise "Станция #{name} уже существует" if @stations.include?(station_by_name(name))

    name
  rescue StandardError => e
    print_error_message e.message
  end

  def ask_station_name
    puts 'Введите название станции'
    name = gets.chomp
    raise "Станции #{name} не существует" unless @stations.include?(station_by_name(name))
    raise 'Вы не ввели названия станций' if name.empty?

    name
  rescue StandardError => e
    print_error_message e.message
  end

  def show_routes
    handle_exception do
      raise NoData, 'Вы не создали ни одного маршрута' if @routes.empty?

      puts 'Список существующих маршрутов:'
      @routes.each_with_index { |route, i| puts "#{i + 1}. #{route.name} " }
    end
  end

  def show_stations
    handle_exception do
      raise NoData, 'Вы не создали ни одной станции.' if @stations.empty?

      puts 'Cписок станций:'
      @stations.each_with_index { |station, i| puts "#{i + 1}. #{station.name} " }
    end
  end

  def station_by_name(station_name)
    @stations.find { |station| station.name == station_name }
  end

  def route_by_name(route_name)
    @routes.find { |route| route.name == route_name }
  end

  def show_list_cargo_carriages(train, train_number)
    puts "Список вагонов в грузовом поезде #{train_number}:"
    train.each_carriage do |cargo_carriage|
      puts "Вагон №#{cargo_carriage.number}. Количество свободного " \
           "объема: #{cargo_carriage.free_volume}. " \
           "Количество занятого объема: #{cargo_carriage.occupied_volume}."
    end
  end

  def show_list_pass_carriages(train, train_number)
    puts "Список вагонов в пассажирском поезде #{train_number}:"
    train.each_carriage do |pass_carriage|
      puts "Вагон №#{pass_carriage.number}. " \
           "Количество свободных мест: #{pass_carriage.free_places}. " \
           "Количество занятых мест: #{pass_carriage.taken_places}."
    end
  end

  def ask_exist_train_number
    handle_exception do
      raise NoData, 'Вы не создали ни одного поезда' if Train.all.empty?

      puts 'Введите номер нужного поезда'
      number = gets.chomp
      raise WrongInput, 'Поезда с таким номером не существует' if Train.find(number).nil?

      number
    end
  end

  def ask_new_train_number
    handle_exception do
      puts 'Введите номер поезда (в формате ххххх или ххх-хх)'
      number = gets.chomp
      raise WrongInput, 'Поезд с таким номером уже существует' if Train.find(number)

      number
    end
  end

  def choose_train_type
    handle_exception do
      puts 'Введите тип поезда: PassengerTrain или CargoTrain'
      type = gets.chomp
      raise WrongInput, 'Такого типа поезда не существует.' unless %w[CargoTrain PassengerTrain].include? type

      type
    end
  end

  def print_error_message(msg)
    warn "Ошибка: #{msg}"
  end

  def handle_exception
    yield
  rescue WrongInput => e
    warn "Ошибка: #{e.message}"
    retry
  rescue NoData => e
    warn "Ошибка: #{e.message}"
    program_process
  rescue NoInput => e
    warn "Ошибка: #{e.message}"
    program_process
  end
end

program = Main.new
program.program_process
