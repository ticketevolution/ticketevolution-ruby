module TicketEvolution
  class CreditMemoPayment < Model

    def apply(params = {})
      plural_class.new(:parent => self.endpoint.parent, :id => self.id).apply(params)
    end

    def cancel(params = {})
      plural_class.new(:parent => self.endpoint.parent, :id => self.id).cancel
    end
  end
end

