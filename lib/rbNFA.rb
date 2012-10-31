require "rbNFA/version"

module RbNFA
  class Regexp
    def initialize(string)
      
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

  class Lexer
    @@tokens = [ LiteralToken, OneOrMoreToken, ZeroOrMoreToken, ZeroOrOneToken,
                 BeginGroupToken]

    def lex(regexp)
      regexp.chars.map do |char|
        @@tokens.select { |token| token.cover(char) }.first.create(char)
      end
    end
  end
end
