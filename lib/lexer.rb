require 'tokens'

module RbNFA
  class Lexer
    @@tokens = [ LiteralToken, OneOrMoreToken, ZeroOrMoreToken, ZeroOrOneToken,
                 BeginGroupToken, EndGroupToken, AlternationToken]

    def lex(regexp)
      regexp.chars.map do |char|
        @@tokens.select { |token| token.cover(char) }.first.create(char)
      end
    end
  end
end
