module TicketEvolution
  class Payment < Model
    def apply
      plural_class.new(:parent => @connection,:id => self.id).apply
    end

    def cancel
      plural_class.new(:parent => @connection,:id => self.id).cancel
    end

    def refund
      plural_class.new(:parent => @connection,:id => self.id).refund
    end
  end
end
