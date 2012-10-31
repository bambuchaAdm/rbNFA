require 'spec_helper.rb'

module RbNFA
  describe Regexp do
    it "can be build from literal string" do 
      regexp = Regexp.new("a")
      regexp.should_not be_nil
    end
    
    it "can math string" do
      pending("to implementig other")
      regexp = Regexp.new("a")
      regexp.match("aaa").should be_true
    end

    it "cannot match incorrect string" do
      pending("implementing other")
      regexp = Regexp.new("a")
      regexp.match("bbb").should be_false
    end
  end

  describe Lexer do
    let(:lexer){ Lexer.new }
        
    it "on empty string don't generate tokens" do
      lexer.lex("").should have(0).tokens
    end

    it "on literal chracter generate literal token" do 
      result = lexer.lex("a")
      result.should have(1).token
      result[0].should be_kind_of LiteralToken
    end

    it "on plus generate one or more token" do 
      result = lexer.lex("+")
      result.should have(1).token
      result.first.should be OneOrMoreToken
    end

    it "on star generate zero or more token" do
      result = lexer.lex("*")
      result.should have(1).token
      result.first.should be ZeroOrMoreToken
    end
      

    it "on question mark generate zero or one token" do
      result = lexer.lex("?")
      result.should have(1).token
      result.first.should be ZeroOrOneToken
    end

    it "on left parenthesie generate begin group token" do
      result = lexer.lex("(")
      result.should have(1).token
      result.first.should be BeginGroupToken
    end

    it "on right parenthiesie generate end group token" do
      result = lexer.lex(")")
      result.should have(1).token
      result.first.should be EndGroupToken
    end

  end
end

