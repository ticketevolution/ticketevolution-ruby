module TicketEvolution
  class Order < Model
    include Model::ParentalBehavior

    def accept(params)
      plural_class.new(:parent => @connection).accept_order(params)
    end

    def complete
      plural_class.new(:parent => @connection).complete_order
    end

    def reject(params)
      plural_class.new(:parent => @connection).reject_order(params)
    end

    def email(params)
      plural_class.new(:parent => @connection,:id => self.id).email_order(params)
    end

    def print
      plural_class.new(:parent => @connection,:id => self.id).print_order
    end
  end
end
