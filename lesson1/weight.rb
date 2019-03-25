puts "Как вас зовут?"
name = gets.chomp

puts "Введите ваш рост (см)."
height = gets.to_i

weight = height - 110

unless weight < 0
    puts "#{name}, привет! Ваш идеальный вес #{weight} кг."  
else
    puts "#{name}, привет! Ваш вес уже оптимальный."
end
