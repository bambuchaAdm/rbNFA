module RbNFA
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

    def process(start,current,prev,stop)
      node = Graph::LiteralNode.new(character)
      current.connect(node)
      return start,node,current,stop
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

    def self.process(start,current,prev,stop)
      return 
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

    def self.process(start,current,prev,stop)
      current.connect(stop)
      return start,start,current,stop
    end
  end
end
