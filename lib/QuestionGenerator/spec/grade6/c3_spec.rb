require_relative '../../grade6/c3.rb'

include Chapter3
describe "Chapter1: " do
  before :each do
    @base_params = {"utf8"=>"blah", "authenticity_token"=>"iDg3LiErTXYf/fvYWyjGAmX457uJQxFYjBomUgTuggA=", "problem_id"=>"343", "commit"=>"Submit Answer", "action"=>"create", "controller"=>"problemanswers"}
  end
  describe "PrimeFactors: " do
    it "should work on an example problem" do
      primefacs = PrimeFactors.new
      primefacs.nums = [2,2,5,17]
      example_params = @base_params.merge({
        "qbans_ans_0"=>"2", 
        "qbans_ans_1"=>"5", 
        "qbans_ans_2"=>"2", 
        "qbans_ans_3"=>"17", 
      })
      primefacs.correct?(example_params).should be_true

      example_params["qbans_ans_3"] = 13
      primefacs.correct?(example_params).should_not be_true
    end
  end

  describe "Factors: " do
    it "should work on an example problem" do
      facs = Factors.new
      facs.nums = [2,3,5]
      example_params = @base_params.merge({
        "qbans_ans_0"=>"2", 
        "qbans_ans_1"=>"5", 
        "qbans_ans_2"=>"3", 
        "qbans_ans_3"=>"15", 
        "qbans_ans_4"=>"10", 
        "qbans_ans_5"=>"6", 
        "qbans_ans_6"=>"1", 
        "qbans_ans_7"=>"30", 
      })
      facs.correct?(example_params).should be_true

      example_params["qbans_ans_3"] = 13
      facs.correct?(example_params).should_not be_true
    end
  end
end
