module RbNFA
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
