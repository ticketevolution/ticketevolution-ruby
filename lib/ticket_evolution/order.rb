module TicketEvolution
  class Order < Model
    include Model::ParentalBehavior

    def accept(params)
      plural_class.new(:parent => @connection,:id => self.id).accept_order(params)
    end

    def return(params)
      plural_class.new(:parent => @connection,:id => self.id).return_order(params)
    end

    def complete
      plural_class.new(:parent => @connection,:id => self.id).complete_order
    end

    def reject(params)
      plural_class.new(:parent => @connection,:id => self.id).reject_order(params)
    end

    def cancel(params)
      plural_class.new(:parent => @connection,:id => self.id).cancel_order(params)
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

    def get_ticket_costs
      plural_class.new(:parent => @connection,:id => self.id).get_ticket_costs
    end

    def update_ticket_costs(params)
      plural_class.new(:parent => @connection,:id => self.id).update_ticket_costs(params)
    end
  end
end
