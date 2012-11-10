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

      def current
        path.last
      end
      
      before :each do 
        start.connect(path.last)
        @start,@path,@stop = token.process(start,path,stop)
      end


      it "connect old current to end" do
        current.next.should include(stop)
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
      let(:prev){ Graph::Node.new }
      let(:current) { n=  Graph::Node.new(); prev.connect(n); n }
      let(:stop) { Graph::Node.new() }

      before :each do
        @start,@current,@prev,@stop = token.process(start,prev,current,stop)
      end
      
      it "create new operation node" do
        @current.should_not be current
        @current.should_not be prev
        @current.should have(0).next
      end

      it "add erge from prev to operation node" do
        @prev.should include(@current)
      end
    end
  end
end


