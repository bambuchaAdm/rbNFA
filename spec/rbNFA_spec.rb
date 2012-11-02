require 'spec_helper.rb'

module RbNFA
  describe Regexp do
    it "can be build from literal string" do 
      regexp = Regexp.new("a")
      regexp.should_not be_nil
    end
    
    it "can math string" do
      regexp = Regexp.new("a")
      regexp.match("aaa").should be_true
    end

    it "cannot match incorrect string" do
      regexp = Regexp.new("a")
      regexp.match("bbb").should be_false
    end
  end

  describe Lexer do
    let(:lexer){ Lexer.new }
        
    it "on empty string don't generate tokens" do
      lexer.lex("").should have(0).tokens
    end

    it "on literal chracter generate literal token" do 
      result = lexer.lex("a")
      result.should have(1).token
      result[0].should be_kind_of LiteralToken
    end

    it "on plus generate one or more token" do 
      result = lexer.lex("+")
      result.should have(1).token
      result.first.should be OneOrMoreToken
    end

    it "on star generate zero or more token" do
      result = lexer.lex("*")
      result.should have(1).token
      result.first.should be ZeroOrMoreToken
    end
      

    it "on question mark generate zero or one token" do
      result = lexer.lex("?")
      result.should have(1).token
      result.first.should be ZeroOrOneToken
    end

    it "on left parenthesie generate begin group token" do
      result = lexer.lex("(")
      result.should have(1).token
      result.first.should be BeginGroupToken
    end

    it "on right parenthiesie generate end group token" do
      result = lexer.lex(")")
      result.should have(1).token
      result.first.should be EndGroupToken
    end

    it "on | create alterantion token" do
      result = lexer.lex("|")
      result.should have(1).token
      result.first.should be AlternationToken
    end
  end

  describe Parser do
    let(:parser){ Parser.new }

    describe "#parse" do
      describe "build" do
        it "empty grapth form empty token stream" do
          graph = parser.parse([])
          graph.begin.should have(1).next
          graph.begin.next.first.should be graph.end
        end

        it "build simple graph form line literal tokens" do
          graph = parser.parse([LiteralToken.new('a'),LiteralToken.new('b')])
          graph.begin.should have(1).next

          a = graph.begin.next.first # Next to begin is 'a'
          a.should have(1).next

          b = a.next.first # Next to 'a' is 'b'
          b.should have(1).next 

          b .next.first.should be graph.end # to end node 
        end

        it "two alternation path" do
          graph = parser.parse([LiteralToken.new('a'), AlternationToken, LiteralToken.new('b')])
          graph.begin.should have(2).next

          left = graph.begin.next[0]
          right = graph.begin.next[1]

          left.should have(1).next
          left.next.first.should be graph.end

          right.should have(1).next
          right.next.first.should be graph.end

        end        


        describe "node" do
          it "with edge avoid him when encounter zero of one token" do
            # /ab?/
            graph = parser.parse([LiteralToken.new('a'),LiteralToken.new('b'),ZeroOrOneToken])
            a = graph.begin.next.first
            a.should have(2).next
            b = a.next.select{ |node| node.kind_of?(Graph::LiteralNode) }.first
            b.should have(1).next
            b.next.first.should be graph.end
          end

          it "with loop on him when encoutner one or more token"

          it "with loop and edge avoid him when encounter zero or more token"

        end
      end


      describe "raise an error when" do
        it "end token doesn't appear"
        it "too much end tokens in stream"
        it "target of operator is not specified"
      end
    end
  end

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


