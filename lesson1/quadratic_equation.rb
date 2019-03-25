puts "Первый коэффициент"
a = gets.chomp.to_i

puts "Второй коэффициент"
b = gets.chomp.to_i

puts "Третий коэффициент"
c = gets.chomp.to_i

# discriminant
d = (b**2) - (4 * a * c)

# find x, x1, x2
x = -b/(2*a)
x1 = (-b + Math.sqrt(d.abs))/(2*a)
x2 = (-b - Math.sqrt(d.abs))/(2*a)

if d < 0
    puts "Дискриминант равен #{d}. Корней нет."
elsif d == 0
    puts "Дискриминант равен #{d}. Один корень, x = #{x}."
else
    puts "Дискриминант равен #{d}. Два корня, x1 = #{x1}, x2 = #{x2}."
end