require 'spec_helper'

module RbNFA
  describe Graph::LiteralNode do
    describe "::enter?" do
      let(:node){ Graph::LiteralNode.new('a') }
      it "return true if arguments is equal to carried letter" do
        node.enter?('a').should be_true
        node.enter?('b').should be_false
      end
    end
  end

  describe Graph::Node do
    describe "::enter?" do
      it "return true evry time" do
        Graph::Node.new.enter?('').should be_true
      end
    end
  end

end
