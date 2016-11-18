require 'spec_helper'

describe TicketEvolution::Collection do
  subject { TicketEvolution::Collection.build_from_response(response, 'brokerages', TicketEvolution::Brokerage) }
  context "without unique_categories" do
    let(:response) { Fake.list_response }

    context "#build_from_response" do
      it { should be_instance_of(TicketEvolution::Collection) }
      it { should be_kind_of(Enumerable) }
      it(:per_page) { should == 2 }
      it(:total_entries) { should == 1379 }
      it(:current_page) { should == 1 }
      it(:status_code) { should == 200 }
      it(:code) { should == 200 }
      it(:unique_categories) { should be_nil }
    end

    context "#each" do
      it "iterates through all the entries" do
        subject.size.should == 2
        subject.each do |entry|
          entry.should be_instance_of TicketEvolution::Brokerage
        end
      end
    end

    describe "#last" do
      it "should pass the request to the @entries array" do
        subject.entries.should_receive(:last)

        subject.last
      end
    end

    describe "#all" do
      it "should alias entries" do
        subject.all.should == subject.entries
      end
    end

    describe "#[]" do
      it "should pass the request to the @entries array" do
        subject.entries.should_receive(:[]).with(1)

        subject[1]
      end
    end
  end

  context "with unique_categories" do
    let(:response) { Fake.list_response_with_unique_categories }

    context "#build_from_response" do
      it { should be_instance_of(TicketEvolution::Collection) }
      it { should be_kind_of(Enumerable) }
      it(:per_page) { should == 2 }
      it(:total_entries) { should == 1379 }
      it(:current_page) { should == 1 }
      it(:status_code) { should == 200 }
      it(:code) { should == 200 }
      it(:unique_categories) { should == [1,2,3,4,5] }
    end

    context "#each" do
      it "iterates through all the entries" do
        subject.size.should == 2
        subject.each do |entry|
          entry.should be_instance_of TicketEvolution::Brokerage
        end
      end
    end

    describe "#last" do
      it "should pass the request to the @entries array" do
        subject.entries.should_receive(:last)

        subject.last
      end
    end

    describe "#all" do
      it "should alias entries" do
        subject.all.should == subject.entries
      end
    end

    describe "#[]" do
      it "should pass the request to the @entries array" do
        subject.entries.should_receive(:[]).with(1)

        subject[1]
      end
    end

  end
end
