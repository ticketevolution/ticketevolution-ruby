module TicketEvolution
  class Item < Model
    def print_etickets
      plural_class.new(:parent => self.endpoint.parent, :id => self.id).print_etickets
    end

    def remove_etickets
      plural_class.new(:parent => self.endpoint.parent, :id => self.id).remove_etickets
    end

    def add_etickets(params = {})
      plural_class.new(:parent => self.endpoint.parent, :id => self.id).add_etickets(params)
    end

    def finalize_etickets(params = {})
      plural_class.new(:parent => self.endpoint.parent, :id => self.id).finalize_etickets(params)
    end

    def convert_to_etickets(params = {})
      plural_class.new(:parent => self.endpoint.parent, :id => self.id).convert_to_etickets
    end
  end
end
