module RbNFA
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
      @prev = nil
      stream.each do |token|
        @begin,@current,@prev,@end = token.process(@begin,@current,@prev,@end)
      end
      @current.connect(@graph.end)
      return @graph
    end
  end
end
