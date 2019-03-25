puts "Первый коэффициент"
a = gets.to_i

puts "Второй коэффициент"
b = gets.to_i

puts "Третий коэффициент"
c = gets.to_i

# discriminant
d = (b**2) - (4 * a * c)

if d < 0
    puts "Дискриминант равен #{d}. Корней нет."
elsif d == 0
    x = -b/(2 * a)
    puts "Дискриминант равен #{d}. Один корень, x = #{x}."
else
    q = Math.sqrt(d)
    x1 = (-b + q)/(2 * a)
    x2 = (-b - q)/(2 * a)
    puts "Дискриминант равен #{d}. Два корня, x1 = #{x1}, x2 = #{x2}."
end
