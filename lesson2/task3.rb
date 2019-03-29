array = [0, 1]
i = 0

while
  i_new = array[i] + array[i.next]
  break if i_new > 100
  array << i_new
  i += 1
end

p array
