require 'lexer'
require 'parser'
require 'matcher'

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
end
