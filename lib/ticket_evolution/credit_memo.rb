module TicketEvolution
  class CreditMemo < Model
    include Model::ParentalBehavior

    def cards(params = nil)
      plural_class.new(:parent => @connection,:id => self.id).cards(params)
    end
  end
end
