require 'spec_helper'

shared_examples_for "a destroy endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#destroy" do
    context "with an id" do
      let(:instance) { klass.new({:parent => connection, :id => 1}) }
      it "should pass call request as a PUT, passing params" do
        instance.should_receive(:request).with(:DELETE, nil, nil)

        instance.destroy
      end

      context "when passed a block" do
        let(:block) { Fake.response_alt }
        let(:response) { Fake.show_response }

        it "should process the response through the block" do
          instance.should_receive(:naturalize_response).and_return(response)

          instance.destroy(&block).should == block.call(response)
        end
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#destroy can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.destroy }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe ".included" do
    let(:model_klass) { instance.singular_class }
    let(:model_instance) { model_klass.new({:connection => connection}) }

    it "should set a destroy method on it's corresponding TE:Model class" do
      model_instance.should respond_to :destroy
    end

    it "should set a delete method on it's corresponding TE:Model class" do
      model_instance.should respond_to :delete
    end
  end

  describe "it's corresponding model object" do
    let(:singular_klass) { Class.new{extend TicketEvolution::SingularClass}.singular_class(klass.name) }

    describe "#destroy" do
      let(:instance) { singular_klass.new(
        :connection => connection,
        :id => 1,
        :name => "John"
      )}

      it "should pass call request as a DELETE" do
        klass.any_instance.should_receive(:request).with(:DELETE, nil, nil).and_return(true)
        instance.destroy.should == true
      end
    end
  end
end

