require "rbNFA/version"

module RbNFA
  class Regexp
    def initialize(string)
      lexer = Lexer.new
      parser = Parser.new
      @matcher = Matcher.new(parser.parse(lexer.lex(string)))
    end
    
    def match(string)
      @matcher.match(string)
    end
  end

  class LiteralToken
    attr_accessor :character

    def initialize(character)
      @character = character
    end

    def self.cover(char)
      ('a'..'z').include?(char) or ('A'..'Z').include?(char)
    end 

    def self.create(char)
      self.new(char)
    end

    def process(start,current,stop)
      node = Graph::LiteralNode.new(character)
      current.connect(node)
      return start,node,stop
    end
  end

  class OneOrMoreToken
    def initialize
      raise "Use as class constant"
    end
    
    def self.cover(char)
      return char == '+'
    end

    def self.create(char)
      self
    end
  end

  class ZeroOrMoreToken
    def initialize
      raise "Use as class constant"
    end
    
    def self.cover(char)
      return char == "*"
    end

    def self.create(char)
      self
    end
  end

  class ZeroOrOneToken
    def initialize
      raise "Use as class constant"
    end

    def self.cover(char)
      return char == "?"
    end

    def self.create(char)
      return self
    end
  end

  class BeginGroupToken 
    def initialize
      raise "Use as class constant"
    end

    def self.cover(char)
      return char == "("
    end

    def self.create(char)
      self
    end
  end

  class EndGroupToken
    def initialize(char)
      raise "Use as class constant"
    end

    def self.cover(char)
      return char == ")"
    end

    def self.create(char)
      self
    end
  end

  class AlternationToken
    def initialize(char)
      raise "USe as class constant"
    end

    def self.cover(char)
      return char == "|"
    end

    def self.create(char)
      self
    end

    def self.process(start,current,stop)
      current.connect(stop)
      return start,start,stop
    end
  end

  class Lexer
    @@tokens = [ LiteralToken, OneOrMoreToken, ZeroOrMoreToken, ZeroOrOneToken,
                 BeginGroupToken, EndGroupToken, AlternationToken]

    def lex(regexp)
      regexp.chars.map do |char|
        @@tokens.select { |token| token.cover(char) }.first.create(char)
      end
    end
  end

  class Graph
    class Node
      attr_reader :next
      def initialize
        @next = []
      end

      def connect(node)
        @next << node unless @next.include?(node)
      end

      def enter?(char)
        true
      end
    end

    class LiteralNode < Node
      def initialize(char)
        super()
        @char = char
      end
      def enter?(char)
        @char == char
      end
    end

    attr_reader :begin, :end

    def initialize
      @begin = Node.new
      @end = Node.new
    end
  end

  class Parser
    def initialize
      @graph = Graph.new
      @begin = @graph.begin
      @end = @graph.end
    end
    
    def parse(stream)
      @current = @begin
      stream.each do |token|
        @begin,@current,@end = token.process(@begin,@current,@end)
      end
      @current.connect(@graph.end)
      return @graph
    end
  end

  class Matcher
    def initialize(graph)
      @graph = graph
    end

    class State
      attr_accessor :node,:position

      def initialize(node,position)
        @node = node
        @position = position
      end

      def next
        @position+1
      end

      def to_s
        "#{@node.to_s} #@position"
      end
    end

    def match(string)
      current = [State.new(@graph.begin,-1)]
      while not current.empty?
        buffer = []
        current.each do |state|
          if state.node == @graph.end
            return true
          end
          state.node.next.each do |neb|
            if neb.enter?(string[state.next])
              buffer << State.new(neb,state.next) 
            end
          end
        end
        current = buffer
      end
      return false
    end
  end
end
