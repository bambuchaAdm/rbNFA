require 'spec_helper'

module RbNFA
  describe LiteralToken do
    describe "::cover" do
      it "return true on letter no mater case" do
        letters = ('a'..'b').to_a + ('A'..'Z').to_a
        letters.each do |letter|
          LiteralToken.cover(letter).should be_true
        end
      end
    end

    describe "#process" do
      let(:token){ LiteralToken.new('a') }
      let(:start){ Graph::Node.new() }
      let(:stop){ Graph::Node.new() }
      let(:path){ [start] }

      before :each do 
        @start,@path,@stop = token.process(start,path,stop)
      end

      it "create new node and add to current" do
        @start.should be start
        @stop.should be stop
        @start.should have(1).next
        @start.next.first.should be @path.last
      end

      it "change current to created node" do
        @path.last.should_not be start
        @path.last.should be_kind_of Graph::LiteralNode
      end
    end
  end
  
  describe AlternationToken do
    describe "::cover" do
      it "return true on |" do
        AlternationToken.cover('|').should be_true
      end
    end

    describe "::process" do
      let(:token){ AlternationToken }
      let(:start){ Graph::Node.new }
      let(:path) { node = Graph::Node.new; start.connect(node);[start, node] }
      let(:stop){ Graph::Node.new }

      before :each do 
        start.connect(path.last)
        @start,@path,@stop = token.process(start,path,stop)
      end

      it "connect old current to end" do
        path.last.next.should include(stop)
      end
      
      it "change new current to start" do 
        @path.should == [start]
      end
    end
  end


  describe ZeroOrOneToken do
    describe "::process" do
      let(:token){ ZeroOrOneToken }
      let(:start){ Graph::Node.new }
      let(:path) { node = Graph::Node.new; start.connect(node);[start, node]}
      let(:stop) { Graph::Node.new }

      before :each do
        @start,@path,@stop = token.process(start,path,stop)
      end

      it "add operation node as end of path" do
        @path.last.should be_kind_of Graph::Node
      end
      
      it "add erge from prev to operation node" do
        (@path[-3]).next.should include(@path.last)
      end
    end
  end

  describe OneOrMoreToken do
    describe "::process" do
      let(:token){ OneOrMoreToken }
      let(:start){ Graph::Node.new }
      let(:node) { Graph::Node.new }
      let(:path) { start.connect(node);[start, node]}
      let(:stop) { Graph::Node.new }

      before :each do
        @start,@path,@stop = token.process(start,path,stop)
      end

      it "add functional node to graph" do
        @path.last.should_not be node
        node.next.should include(@path.last)
      end

      it "craete loop in process node" do
        node.next.should include(node)
      end
    end
  end
end


