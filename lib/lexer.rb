require 'tokens'

module RbNFA
  class Lexer
    @@TOKENS = [ OneOrMoreToken, ZeroOrMoreToken, ZeroOrOneToken,
                 BeginGroupToken, EndGroupToken, AlternationToken]

    def lex(regexp)
      skip = false
      result = []
      regexp.chars.with_index do |char,index|
        if skip 
          skip = false
        elsif char == '\\'
          result << LiteralToken.new(regexp[index+1])
          skip = true
        else    
          possible = @@TOKENS.select { |token| token.cover(char) }
          if not possible.empty?
            result << possible.first.create(char)
          else
            result << LiteralToken.new(char)
          end
        end
      end
      result
    end
  end
end
