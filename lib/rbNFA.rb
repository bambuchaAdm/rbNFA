require "rbNFA/version"

module RbNFA
  class Regexp
    def initialize(string)
      
    end
  end

  class Lexer
    def lex(regexp)
      tokens = []
      regexp.each_char do |char|
        case char
          when 'a'..'z' then tokens << LiteralToken.new(char)
          when 'A'..'Z' then tokens << LiteralToken.new(char4)
          when '+' then tokens << OneOrMoreToken
        end
      end
      tokens
    end
  end

  class LiteralToken
    attr_accessor :character
    def initialize(character)
      @character = character
    end
  end

  class OneOrMoreToken
    def initialize
      raise "Use as class constant"
    end
  end
end
