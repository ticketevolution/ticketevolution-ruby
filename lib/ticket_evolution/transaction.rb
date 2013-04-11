module TicketEvolution
  class Transaction < Model
    def balances(params = nil)
      plural_class.new(:parent => @connection,:id => self.id).balances(params)
    end
  end
end
