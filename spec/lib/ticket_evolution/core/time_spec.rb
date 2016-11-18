require 'spec_helper'

describe TicketEvolution::Time do
  let(:klass) { TicketEvolution::Time }

  subject { klass }

  it(:ancestors) { should include ::Time }

  describe "#parse" do
    context "with a valid string" do
      let(:str) { "2011-12-18T17:30:06Z" }
      let(:expected) { klass.gm(2011,12,18,17,30,06) }

      subject { klass.parse(str) }

      it { should == expected }
    end

    describe "with an invalid string" do
      let(:str) { "I've got a lovely bunch of coconuts." }

      subject { klass.parse(str) }

      it { should == str }
    end
  end
end
