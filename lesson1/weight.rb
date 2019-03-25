puts "Как вас зовут?"
name = gets.chomp

puts "Введите ваш рост (см)."
height = gets.chomp

weight = height.to_i - 110

unless weight < 0
    puts "#{name}, привет! Ваш идеальный вес #{weight} кг."  
else
    puts "Ваш вес уже оптимальный."
end