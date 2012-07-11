module TicketEvolution
  class TicketGroup < Model
    def hold(params)
      plural_class.new(:parent => @connection, :id => self.id).hold(params)
    end
    def waste(params)
      plural_class.new(:parent => @connection, :id => self.id).waste(params)
    end
    def toggle_broadcast(params)
      plural_class.new(:parent => @connection, :id => self.id).toggle_broadcast(params)
    end
  end
end
