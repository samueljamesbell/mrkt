require_relative 'offer'

class Ask < Offer
    include Java::JavaLang::Comparable
    java_signature 'int compareTo(Ask)'

    def compareTo(other)
        result = 0

        if @price > other.price
            result = 1
        elsif @price < other.price
            result = -1
        end

        result
    end
end
