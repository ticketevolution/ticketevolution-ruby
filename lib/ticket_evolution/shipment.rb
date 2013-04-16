module TicketEvolution
  class Shipment < Model
    def generate_airbill
      plural_class.new(:parent => @connection, :id => self.id).generate_airbill
    end
    def get_airbill
      plural_class.new(:parent => @connection, :id => self.id).get_airbill
    end
    def email_airbill(params)
      plural_class.new(:parent => @connection, :id => self.id).email_airbill(params)
    end
    def cancel
      plural_class.new(:parent => @connection, :id => self.id).cancel_shipment
    end
    def deliver
      plural_class.new(:parent => @connection, :id => self.id).deliver_shipment
    end
    def pend
      plural_class.new(:parent => @connection, :id => self.id).pend_shipment
    end
  end
end
