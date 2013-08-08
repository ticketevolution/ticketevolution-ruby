module TicketEvolution
  class TicketGroup < Model
    def hold(params)
      plural_class.new(:parent => @connection, :id => self.id).hold(params)
    end
    def take(params)
      plural_class.new(:parent => @connection, :id => self.id).take(params)
    end
    def update_hold(params)
      plural_class.new(:parent => @connection, :id => self.id).update_hold(params)
    end
    def release_hold(params)
      plural_class.new(:parent => @connection, :id => self.id).release_hold(params)
    end
    def release_take(params)
      plural_class.new(:parent => @connection, :id => self.id).release_take(params)
    end
    def waste(params)
      plural_class.new(:parent => @connection, :id => self.id).waste(params)
    end
    def toggle_broadcast(params)
      plural_class.new(:parent => @connection, :id => self.id).toggle_broadcast(params)
    end
    def import(params)
      plural_class.new(:parent => @connection, :id => self.id).import(params)
    end
  end
end
