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

    def process(start,path,stop)
      node = Graph::LiteralNode.new(character)
      path.last.connect(node)
      path.push(node)
      return start,path,stop
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
    
    def self.process(start,path,stop)
      node = Graph::Node.new
      path.last.connect(node)
      path.last.connect(path.last)
      path << node 
      return start,path,stop
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

    def self.process(start,path,stop)
      node = Graph::Node.new
      path.last.connect node
      path[-2].connect(node)
      path << node 
      return start,path,stop
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

    def self.process(start,path,stop)
      path.last.connect(stop)
      return start,[start],stop
    end
  end
end
