require 'spec_helper'

module RbNFA
  describe Matcher do
    it "take graph at building" do
      Matcher.new(Graph.new).should_not be_nil
    end
    describe "#match" do
      let(:graph) { Graph.new }
      it "return true on match empty grap" do 
        graph.begin.connect(graph.end)
        result = Matcher.new(graph).match('')
        result.should be_true
      end

      it "return true on match 'a' on 'a' string" do
        letter = Graph::LiteralNode.new('a')
        graph.begin.connect(letter)
        letter.connect(graph.end)
        Matcher.new(graph).match('a').should be_true
      end

      it "return false on match 'a' on 'b' string" do
        letter = Graph::LiteralNode.new('b')
        graph.begin.connect(letter)
        letter.connect(graph.end)
        Matcher.new(graph).match('b').should be_true
      end
    end
  end
end
