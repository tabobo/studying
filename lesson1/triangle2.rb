puts "Длина первой стороны треугольника"
a = gets.chomp.to_i

puts "Длина второй стороны треугольника"
b = gets.chomp.to_i

puts "Длина третьей стороны треугольника"
c = gets.chomp.to_i
    
if ((a > b && a > c) && (b**2 + c**2 == a**2)) || ((b > a && b > c) && (a**2 + c**2 == b**2)) || ((c > a && c > b) && (a**2 + b**2 == c**2))
    puts "Треугольник прямоугольный"
else 
    puts "Треугольник не прямоугольный"
end

puts "Треугольник равнобедренный" if a == b || b == c || a == c

puts "Треугольник равнобедренный и равносторонний" if a == b && b == c

