# == Schema Information
#
# Table name: quizzes
#
#  id           :integer         not null, primary key
#  problemtypes :binary
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string
#

require 'spec_helper'

describe Quiz do
  before :each do
    @quiz = Quiz.find(1)
  end

  it "test should use TEST quiz owned by t.homasramfjord" do
    @quiz.name.should == "TEST"
  end


  describe "add_problem_types" do
    it "should create/return a new quiz_problem_type when given a valid problem_type" do
      @quiz.add_problem_type 
    end

    it "should return the existing quiz_problem_type when given a problem_type that's already part of the quiz" do
    end

    it "should do nothing when given nil" do
    end
  end

  describe "remove_problem_type" do
    it "should delete the corresponding quiz_problem_type when given a problem type that's part of the quiz" do
    end

    it "should do nothing when given a problem_type that isn't in the quiz" do
    end
  end
end
