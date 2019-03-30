array = [0, 1]

loop do
  i_new = array[-1] + array[-2]
  break if i_new > 100
  array << i_new
end

p array
