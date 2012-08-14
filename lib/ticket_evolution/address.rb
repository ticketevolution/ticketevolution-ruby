module TicketEvolution
  class Address < Model
    def fedex_check
      plural_class.new(:parent => @connection,:id => self.id).fedex_check
    end

  end
end
