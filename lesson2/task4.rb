alphabet = ('a'..'z').to_a
vowels = %w(a e i o u)
vowels_hash = {}

vowels.each { |vowel| vowels_hash[vowel] = alphabet.index(vowel) + 1 }

p vowels_hash
