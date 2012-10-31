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
    
    it "can lex a string into token stream" do
      lexer.lex("").should have(0).tokens
    end
    
    it "on empty string don't generate tokens"

    it "on literal chracter generate literal token"

    it "on plus generate one or more token"

    it "on star generate zero or more token"

    it "on question mark generate zero or one token"

    it "on left parenthesie generate begin group token"

    it "on right parenthiesie generate end group token"

  end
end

