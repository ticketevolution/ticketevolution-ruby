module TicketEvolution
  class Payment < Model
    def apply(params)
      plural_class.new(:parent => @connection, :id => self.id).apply(params)
    end

    def cancel(params)
      plural_class.new(:parent => @connection, :id => self.id).cancel(params)
    end

    private

    def plural_class
      TicketEvolution::Orders::Payments
    end
  end
end
