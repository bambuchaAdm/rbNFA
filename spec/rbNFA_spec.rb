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

    it "on | create alterantion token" do
      result = lexer.lex("|")
      result.should have(1).token
      result.first.should be AlternationToken
    end
  end

  describe Parser do
    let(:parser){ Parser.new }

    describe "#parse" do
      let(:parse) { parser.parse }

      describe "build" do
        it "empty grapth form empty token stream"

        it "two alternation path"

        describe "node" do

          it "with letter"

          it "with edge avoid him when encounter zero of one token"

          it "with loop on him when encoutner one or more token"

          it "with loop and edge avoid him when encounter zero or more token"

        end

      end


      describe "raise an error when" do
        it "end token doesn't appear"
        it "too much end tokens in stream"
        it "target of operator is not specified"
      end
    end
  end
end

