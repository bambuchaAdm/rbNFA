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

      before :each do 
        @start,@current,@prev,@stop = token.process(start,start,nil,stop)
      end

      it "create new node and add to current" do
        @start.should be start
        @stop.should be stop
        @start.should have(1).next
        @start.next.first.should be @current
      end

      it "change current to created node" do
        @current.should_not be start
        @current.should be_kind_of Graph::LiteralNode
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
      let(:start){ Graph::Node.new() }
      let(:current) { Graph::Node.new() }
      let(:stop){ Graph::Node.new() }
      
      before :each do 
        start.connect(current)
        @start,@current,@prev,@stop = token.process(start,current,nil,stop)
      end

      it "connect old current to end" do
        current.next.should include(stop)
      end
      
      it "change new current to start" do 
        @current.should be start
      end
    end
  end


  describe ZeroOrOneToken do
    describe "::process" do
      let(:token){ ZeroOrOneToken }
      let(:start){ Graph::Node.new }
      let(:prev){ Graph::Node.new }
      let(:current) { n=  Graph::Node.new; prev.connect(n); n }
      let(:stop) { Graph::Node.new }
      
      before :each do
        @start,@current,@prev,@stop = ZeroOrOneToken.process(start,prev,current,stop)
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


