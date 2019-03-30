cart = {}

loop do
  puts "Название товара (или 'стоп'):"
  name = gets.chomp
  break if name == "стоп"

  puts "Цена за единицу"
  price = gets.chomp.to_f

  puts "Количество купленного товара"
  amount = gets.chomp.to_f
    
  cart[name] = { price: price, amount: amount, name_sum: price * amount }
end

cart_sum = cart.values.sum { |properties| properties[:name_sum] }

puts cart
puts "Итоговая сумма всех покупок: #{cart_sum}"
