require 'spec_helper'

describe TicketEvolution::TicketGroup do
  subject { TicketEvolution::TicketGroup }
  let(:klass) { TicketEvolution::TicketGroup }
  let(:connection) { Fake.connection }
  let(:instance) { klass.new({:connection => connection, 'id' => 1}) }
  let(:params) { {:test => "1... 2... 3..."} }
  let(:plural_klass) { TicketEvolution::TicketGroups }
  let!(:plural_klass_instance) { plural_klass.new(:parent => connection) }

  it_behaves_like "a ticket_evolution model"

  describe "#hold" do
    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it "should pass the request to TicketEvolution::TicketGroups#hold" do
      plural_klass_instance.should_receive(:hold).with(params).and_return(:dont_care)
      instance.hold(params)
    end
  end
  
  describe "#update_hold" do

    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it "should pass the request to TicketEvolution::TicketGroups#update_hold" do
      plural_klass_instance.should_receive(:update_hold).with({ :ticket_hold_id => 1 }).and_return(:dont_care)
      instance.update_hold({ :ticket_hold_id => 1 })
    end
  end

  describe "#release_hold" do

    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it "should pass the request to TicketEvolution::TicketGroups#release_hold" do
      plural_klass_instance.should_receive(:release_hold).with({ :ticket_hold_id => 1 }).and_return(:dont_care)
      instance.release_hold({ :ticket_hold_id => 1 })
    end
  end

  describe "#take" do
    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it "should pass the request to TicketEvolution::TicketGroups#take" do
      plural_klass_instance.should_receive(:take).with(params).and_return(:dont_care)
      instance.take(params)
    end
  end

  describe "#release_take" do

    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it "should pass the request to TicketEvolution::TicketGroups#release_take" do
      plural_klass_instance.should_receive(:release_take).with({ :ticket_taken_id => 1 }).and_return(:dont_care)
      instance.release_take({ :ticket_taken_id => 1 })
    end
  end

end
