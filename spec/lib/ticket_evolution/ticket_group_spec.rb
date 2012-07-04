require 'spec_helper'

describe TicketEvolution::TicketGroup do
  subject { TicketEvolution::TicketGroup }
  let(:klass) { TicketEvolution::TicketGroup }

  it_behaves_like "a ticket_evolution model"

  describe "#hold" do
    let(:connection) { Fake.connection }
    let(:instance) { klass.new({:connection => connection, 'id' => 1}) }
    let(:params) { {:test => "1... 2... 3..."} }
    let(:plural_klass) { TicketEvolution::TicketGroups }
    let!(:plural_klass_instance) { plural_klass.new(:parent => connection) }

    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it "should pass the request to TicketEvolution::TicketGroups#hold" do
      plural_klass_instance.should_receive(:hold).with(params).and_return(:dont_care)
      instance.hold(params)
    end
  end
end
