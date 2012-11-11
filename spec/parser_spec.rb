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


        context "node" do
          it "with edge avoid him when encounter zero of one token" do
            # /b?/
            graph = parser.parse([LiteralToken.new('b'),
                                  ZeroOrOneToken])
            graph.begin.should have(2).next
            b = graph.begin.next.first
            b.should have(1).next
            function_node = b.next.first
            function_node.next.should == [graph.end]
          end

          it "with loop on him when encoutner one or more token" do
            # /a+/
            graph = parser.parse([LiteralToken.new('a'),OneOrMoreToken])
            a = graph.begin.next.first
            a.should have(2).next
            a.next.should include(a)
            a.next.first.next.should include(graph.end)
          end

          it "with loop and edge avoid him when encounter zero or more token" do
            # /a*/
            graph = parser.parse([LiteralToken.new('a'),ZeroOrMoreToken])
            graph.begin.should have(2).next
            a = graph.begin.next.first
            a.next.should include(a)
            functional_node = a.next.first
            functional_node.next.should == [graph.end]
          end
        end
      end

      it "don't reaise na error when regexp starts with alternation token" do
        lambda{ parser.parse([AlternationToken,LiteralToken.new('a')])}.should_not raise_error
      end

      describe "raise an error when" do
        it "end token doesn't appear" do
          lambda { parser.parse([BeginGroupToken]) }.should raise_error ParseError
        end

        it "too much end tokens in stream" do
          lambda { parser.parse([EndGroupToken]) }.should raise_error ParseError
        end
        it "target of operator is not specified" do
          lambda { parser.parse([OneOrMoreToken]) }.should raise_error ParseError
        end
      end
    end
  end
end
