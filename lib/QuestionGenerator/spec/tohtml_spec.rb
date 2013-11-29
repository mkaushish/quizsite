require_relative '../tohtml.rb'

include ToHTML
describe "ToHTML" do
  describe "add_prefix" do
    it "should add a prefix when there isn't one" do
      ToHTML::add_prefix("hello").should == "#{ToHTML::PREFIX}hello"
    end

    it "should not add a prefix when there is already one" do
      prefname = ToHTML::add_prefix "hello"
      ToHTML::add_prefix(prefname).should == prefname
    end
  end

  describe "rm_prefix" do
    before :each do
      @name = "hello"
      @prefname = ToHTML::add_prefix @name
    end

    it "should remove the prefix if there is one" do
      ToHTML::rm_prefix(@prefname).should == @name
    end

    it "should leave the string unchanged if there's no prefix" do
      ToHTML::rm_prefix(@name).should == @name
    end
  end

  describe "InputField" do
    it "fromhash should grab the hash element corresponding to the field name" do
      blah = TextField.new("hello")
      blah.fromhash({ToHTML::add_prefix("hello") => 123}).should == 123
    end
  end

  describe "MultiTextField" do
    before :each do
      @name = "ans"
    end

    it "should create a new MultiTextField given just a name, and add a prefix to the name appropriately" do
      mtf = MultiTextField.new(@name)
      mtf.name().should == ToHTML::add_prefix(@name)
    end

    it "should have a working each_name method" do
      n = 5
      realnames = (0...n).map { |i| ToHTML::add_prefix "#{@name}_#{i}" }
      names = []
      mtf = MultiTextField.new(@name, 5)

      mtf.each_name { |name| names << name }
      names.should == realnames
    end

    describe "length_from_hash" do
      it "should find the number of elements by looking at a hash" do
        @mtf = MultiTextField.new("ans")
        hash = {}
        5.times do |i|
          hash["qbans_ans_#{i}"] = i
        end
        @mtf.length_from_hash hash
        @mtf.num.should == 5
      end
    end

    describe "hash_to_arr" do
      it "should convert hash format to array" do
        @mtf = MultiTextField.new("ans", 5)
        hash = {}
        5.times do |i|
          hash["qbans_ans_#{i}"] = i
        end
        @mtf.hash_to_arr(hash).sort.should == (0...5).to_a
      end
    end

    it "fromhash should work on subfields even if hash is in array form" do 
      @mtf = MultiTextField.new("ans",3)
      hash = {ToHTML::add_prefix("ans") => [1,2,3]}
      @mtf.each_field do |field|
        field.fromhash(hash).should_not be_nil
      end
    end

    describe "correct method" do
      before :each do
        @n = 5
        @mtf = MultiTextField.new("ans", @n)
        @keys = []
        @vals = (1..5).map { |i| i.to_s }
        @solution = {"irrelevant" => "blah123", "ans32" => "152"}
        @response = {"irrelevant" => "ldkjfsd", "ans32" => "152", "extrastuff" => "12"}

        i = 0
        @mtf.each_name do |name|
          @solution[name] = @vals[i]
          @response[name] = @vals[i]
          @keys << name
          i += 1
        end
      end

      it "should return true if the solution and response fields match on" do
        @mtf.correct?(@solution, @response).should == true
      end

      it "should return true even if answers aren't in order" do
        tmp = @response[@keys[0]]
        @response[@keys[0]] = @response[@keys[1]]
        @response[@keys[1]] = tmp

        @mtf.correct?(@solution, @response).should == true
      end

      it "should return false if one of the answers is wrong" do
        @response[@keys[2]] = "wronganswer"
        @mtf.correct?(@solution, @response).should == false
      end
    end
  end

  # TODO add to this...
end
