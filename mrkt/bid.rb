require 'offer'

class Bid < Offer
    include Java::JavaLang::Comparable
    java_signature 'int compareTo(Bid)'

    def compareTo(other)
        result = 0

        if @price < other.price
            result = 1
        elsif @price > other.price
            result = -1
        end

        result
    end
end
