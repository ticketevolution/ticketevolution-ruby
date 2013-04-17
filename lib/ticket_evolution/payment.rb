module TicketEvolution
  class Payment < Model
    include Model::ParentalBehavior

    def apply(params=nil)
      plural_class.new(:parent => @connection,:id => self.id).apply(params)
    end

    def cancel
      plural_class.new(:parent => @connection,:id => self.id).cancel
    end

    def refund(params=nil)
      plural_class.new(:parent => @connection,:id => self.id).refund(params)
    end
  end
end
