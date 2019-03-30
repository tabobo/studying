puts "Date"
day = gets.to_i

puts "Month"
month = gets.to_i

puts "Year"
year = gets.to_i

days_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
days_month[1] = 29 if year % 400 == 0 || ( year % 4 ==0 && year % 100 != 0)

result = days_month.take(month - 1).sum + day

puts "Порядковый номер даты: #{result}" 
