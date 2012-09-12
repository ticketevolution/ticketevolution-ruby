module TicketEvolution
  class Address < Model
    def check
      plural_class.new(:parent => @connection,:id => self.id).check
    end

    def check_fields
      plural_class.new(:parent => @connection).check_fields
    end

  end
end
