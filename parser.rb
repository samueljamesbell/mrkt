require "rubygems"
require "bundler/setup"

require "fastercsv"

prices = CSV.read "data/KO.csv"

header = prices.shift
d = Hash[prices[0].collect { |i| i }]

puts d
puts prices[0]



