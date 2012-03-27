require_relative '../../grade6/c1.rb'

# TODO write these things out... Do I have to?

describe "Chapter1: " do
  before(:each) do
    @asc_array1 = [847, 9754, 8320, 571]
    @asc_array2 = [9801, 25751, 36501, 38802]
    @desc_array1 = [5000, 7500, 85400, 7861]
    @desc_array2 = [1971, 45321, 88715, 92547]
  end
  
  it "FindMaxNumber should work on the example problem" do
    prob = Chapter1::FindMaxNumber.new
    prob.nums = @asc_array1
    prob.correct?(9754).should == true

    prob.nums = @asc_array2
    prob.correct?(38802).should == true
  end

  it "FindMinNumber should work on the example problem" do
  end

  it "ArrangeAscending should work on the example problem" do
    prob = Chapter1::ArrangeAscending.new
    prob.nums = @asc_array1
    prob.correct?([571, 847, 8320, 9754]).should == true

    prob.nums = @asc_array2
    prob.correct?([9801, 25751, 36501, 38802]).should == true
  end

  it "ArrangeDescending should work on the example problem" do
  end

  it "WritingIndian should work on the example problem" do
  end

  it "WritingInternational should work on the example problem" do
  end

  it "AddCommasIndian should work on the example problem" do
  end

  it "AddCommasInternational should work on the example problem" do
  end

  it "ReadingInternational should work on the example problem" do
  end

  it "ReadingIndian should work on the example problem" do
  end

  it "EstimateArithmetic should work on the example problem" do
  end

  it "ToRoman should work on the example problem" do
  end

  it "ToArabic should work on the example problem" do
  end
end
