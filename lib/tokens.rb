module RbNFA
  class LiteralToken < Struct.new(:character)

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

  module OneOrMoreToken
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

  module ZeroOrMoreToken
    def self.cover(char)
      return char == "*"
    end

    def self.create(char)
      self
    end

    def self.process(start,path,stop)
      node = Graph::Node.new
      path.last.connect(node)
      path.last.connect(path.last)
      path[-2].connect(node)
      path << node 
      return start,path,stop
    end
  end

  module ZeroOrOneToken
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

  module BeginGroupToken 
    def self.cover(char)
      return char == "("
    end

    def self.create(char)
      self
    end
  end

  module EndGroupToken
    def self.cover(char)
      return char == ")"
    end

    def self.create(char)
      self
    end
  end

  module AlternationToken
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
