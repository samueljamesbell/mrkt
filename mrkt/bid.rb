require 'Offer'

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

    def update_budgets(offer, price)
        @trader.budget -= offer.remaining_quantity * price
        offer.trader.budget += @remaining_quantity * price
    end
end
