require 'spec_helper'

shared_examples_for "an update endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#update" do
    context "with an id" do
      let(:instance) { klass.new({:parent => connection, :id => 1}) }

      context "with params" do
        let(:params) { {:name => "Bob"} }

        it "should pass call request as a PUT, passing params" do
          instance.should_receive(:request).with(:PUT, nil, params)

          instance.update(params)
        end
      end

      context "without params" do
        it "should pass call request as a PUT, passing params" do
          instance.should_receive(:request).with(:PUT, nil, nil)

          instance.update
        end
      end

      context "when passed a block" do
        let(:block) { Fake.response_alt }
        let(:response) { Fake.show_response }

        it "should process the response through the block" do
          instance.should_receive(:naturalize_response).and_return(response)

          instance.update({}, &block).should == block.call(response)
        end
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#update can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.update }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe ".included" do
    let(:model_klass) { instance.singular_class }
    let(:model_instance) { model_klass.new(attributes.merge({:connection => connection})) }
    let(:attributes) { HashWithIndifferentAccess.new(update_base.merge({:one => 1, :two => "two", :three => nil, :id => 1})) }

    it "should set an update_attributes method on it's corresponding TE:Model class" do
      model_instance.should respond_to :update_attributes
    end

    it "should set a save method on it's corresponding TE:Model class" do
      model_instance.should respond_to :save
    end
  end

  describe "it's corresponding model object" do
    let(:singular_klass) { Class.new{extend TicketEvolution::SingularClass}.singular_class(klass.name) }

    describe "#update_attributes" do
      let(:instance) { singular_klass.new(update_base.merge({
        :connection => connection,
        :id => 1,
        :first_name => "John",
        :last_name => "Doe"
      })) }
      let(:params) { {:first_name => "Bob"} }
      let(:response) { mock(:response, :attributes => params) }

      it "should pass call request as a PUT, passing params" do
        klass.any_instance.should_receive(:request).with(:PUT, nil, params).and_return(response)

        instance.update_attributes(params)
      end
    end

    describe "#save" do
      let(:instance) { singular_klass.new(update_base.merge({
        :connection => connection,
        :id => 1,
        :first_name => "John",
        :last_name => "Doe"
      })) }
      let(:expected) do
        data = instance.attributes
        data.delete(:id)
        data
      end
      let(:response) { mock(:response, :attributes => {}) }

      it "should pass call request as a PUT, passing params" do
        klass.any_instance.should_receive(:request).with(:PUT, nil, expected).and_return(response)

        instance.save
      end
    end
  end
end
