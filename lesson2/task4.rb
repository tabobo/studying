alphabet = (:a..:z).to_a
vowels = %i(a e i o u)
vowels_hash = Hash.new

vowels.each { |vowel| vowels_hash[vowel] = alphabet.index(vowel) + 1 }

p vowels_hash
