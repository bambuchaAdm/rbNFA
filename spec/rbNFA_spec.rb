require 'spec_helper.rb'

module RbNFA
  describe Regexp do
    it "can be build from literal string" do 
      regexp = Regexp.new("a")
      regexp.should_not be_nil
    end
    
    it "can math string" do
      regexp = Regexp.new("a")
      regexp.match("aaa").should be_true
    end

    it "cannot match incorrect string" do
      regexp = Regexp.new("a")
      regexp.match("bbb").should be_false
    end
    
    it "return match object" do
      regexp = Regexp.new("a(b+)c")
      result = regexp.match("abbbbc")
      result.first.should eql "bbbb"
    end
  end
end

