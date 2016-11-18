require 'spec_helper'

shared_examples_for "a ticket_evolution model" do
  let(:klass) { subject }
  let(:instance) { klass.new({:connection => Fake.connection}) }

  it(:ancestors) { should include TicketEvolution::Model }

  describe "#attributes" do
    let(:hash) { { "hash" => { "test" => "1.. 2... 3...." } } }

    it "should return a hash of attribute key/pair values" do
      instance.one = 1
      instance.two = 2
      instance.three = nil

      instance.attributes.should == {"one" => 1, "two" => 2, "three" => nil}
    end

    it "should return a HashWithIndifferentAccess" do
      instance.attributes.should be_a HashWithIndifferentAccess
    end

    it "should convert OpenStruct based objects back into hashes recursively" do
      instance.hash = hash
      instance.attributes.should == { "hash" => hash }
    end
  end

  describe "#to_hash" do
    context "of a list" do
      let(:hash) { { :test => [1,2,3,4,5] } }
      before { instance.hash = hash }
      it "should return the same list" do
        instance.to_hash.should == { :hash => hash }
      end
    end
  end
end

shared_examples_for "a parental model" do
  let(:klass) { subject }
  let(:instance) { klass.new({:connection => Fake.connection}) }
  let(:sample_klass) { instance.plural_class::Samples }

  describe "#new_ostruct_member" do
    context "when the member name refers to an endpoint" do
      before do
        instance.samples = []
      end

      it "should respond with the value" do
        instance.samples.should == []
      end

      it "should fall back on the endpoint" do
        sample_klass.any_instance.should_receive(:send).with(:testing)

        instance.samples.testing
      end
    end

    context "when the member name does not refer to an endpoint" do
      before do
        instance.not_samples = []
      end

      it "should respond with the value" do
        instance.not_samples.should == []
      end

      it "should add endpoint methods" do
        instance.not_samples.should_not be_respond_to(:endpoint=)
      end
    end
  end
end
