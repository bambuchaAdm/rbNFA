require 'spec_helper'

module RbNFA
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
          graph = parser.parse([LiteralToken.new('a'), 
                                AlternationToken,
                                LiteralToken.new('b')])
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
            graph = parser.parse([LiteralToken.new('b'),
                                  ZeroOrOneToken])
            graph.begin.should have(2).next
            b = graph.begin.next.first
            b.should have(1).next
            function_node = b.next.first
            function_node.next.should == [graph.end]
          end

          it "with loop on him when encoutner one or more token" do
            graph = parser.parse([LiteralToken.new('a'),OneOrMoreToken])
            a = graph.begin.next.first
            a.should have(2).next
            a.next.should include(a)
            a.next.first.next.should include(graph.end)
          end

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
end
