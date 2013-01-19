module TicketEvolution
  class Order < Model
    include Model::ParentalBehavior

    def accept(params)
      plural_class.new(:parent => @connection,:id => self.id).accept_order(params)
    end

    def refund(params)
      plural_class.new(:parent => @connection,:id => self.id).refund_order(params)
    end

    def complete
      plural_class.new(:parent => @connection,:id => self.id).complete_order
    end

    def reject(params)
      plural_class.new(:parent => @connection,:id => self.id).reject_order(params)
    end

    def email(params)
      plural_class.new(:parent => @connection,:id => self.id).email_order(params)
    end

    def store_etickets(params)
      deliver_etickets(params)  # renamed action to deliver_etickets
    end

    def deliver_etickets(params)
      plural_class.new(:parent => @connection,:id => self.id).deliver_etickets(params)
    end

    def email_etickets_link(params)
      plural_class.new(:parent => @connection,:id => self.id).email_etickets_link(params)
    end

    def print_etickets(params = nil)
      plural_class.new(:parent => @connection,:id => self.id).print_etickets(params)
    end

    def print(params = nil)
      plural_class.new(:parent => @connection,:id => self.id).print_order(params)
    end
  end
end
