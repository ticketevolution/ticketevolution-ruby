require 'spec_helper'

describe TicketEvolution::Orders do
  let(:klass) { TicketEvolution::Orders }
  let(:single_klass) { TicketEvolution::Order }
  let(:instance) { klass.new({:parent => Fake.connection}) }
  let(:update_base) { {} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'

  it "should respond to create_brokerage_order" do
    instance.should respond_to :create_brokerage_order
  end

  it "should respond to create_customer_order" do
    instance.should respond_to :create_customer_order
  end

  describe "#accept_order" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }

      context "with params" do
        let(:params) { {:reviewer_id => 1} }

        it "should pass call request as a POST, passing params" do
          instance.should_receive(:request).with(:POST, "/accept", params)

          instance.accept_order(params)
        end
      end

      context "without params" do
        it "should pass call request as a POST, passing params" do
          instance.should_receive(:request).with(:POST, "/accept", nil)

          instance.accept_order
        end
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#accept_order can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.accept_order }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe "#pend_to_seller" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }
      let(:params) {{ :id => instance.id }}

      it "should pass call request as a POST" do
        instance.should_receive(:request).with(:POST, "/1/pend_to_seller", params)

        instance.pend_to_seller(params)
      end
    end

    context "without an id" do
      it "should raise an ArgumentError if there is no id" do
        expect { instance.pend_to_seller() }.to raise_error ArgumentError
      end
    end
  end

  describe "#create_fulfillment_order" do
    context "with params" do
      let(:params) { {'some' => {'order' => 'info'}} }

      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, "/fulfillments", params)

        instance.create_fulfillment_order(params)
      end
    end

    context "without params" do
      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, "/fulfillments", nil)

        instance.create_fulfillment_order
      end
    end
  end

  describe "#reject_order" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }

      context "with params" do
        let(:params) { {:rejection_reason => "IT'S A TRAP!!", :reviewer_id => 1} }

        it "should pass call request as a POST, passing params" do
          instance.should_receive(:request).with(:POST, "/reject", params)

          instance.reject_order(params)
        end
      end

      context "without params" do
        it "should pass call request as a POST, passing params" do
          instance.should_receive(:request).with(:POST, "/reject", nil)

          instance.reject_order
        end
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#reject_order can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.reject_order }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe "#complete_order" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }

      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, "/complete", nil)

        instance.complete_order
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#complete_order can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.complete_order }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe "#balance" do
    context "with params" do
      let(:params) { {'some' => {'order' => 'info'}} }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, "/balance", params)
        instance.balance(params)
      end
    end
  end
end
