module TicketEvolution
  class Address < Model
    def fedex_check
      plural_class.new(:parent => @connection,:id => self.id).fedex_check
    end

    def fedex_check_fields
      plural_class.new(:parent => @connection).fedex_check_fields
    end

  end
end
