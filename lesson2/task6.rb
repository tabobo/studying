cart = Hash.new
every_sum = Hash.new
sum = 0

loop do
  puts "Название товара (или 'стоп'):"
  name = gets.chomp
  break if name == "стоп"

  puts "Цена за единицу"
  price = gets.chomp.to_f

  puts "Количество купленного товара"
  amount = gets.chomp.to_f
    
  every_sum = { "name" => name, "sum" => price * amount }
  puts "Сумма за #{name}: #{every_sum["sum"]}"

  cart[name] = { "price" => price, "amount" => amount}
end

cart.each { |name, hash| sum += hash["price"] * hash["amount"] }

puts cart
puts "Итоговая сумма всех покупок: #{sum}"
