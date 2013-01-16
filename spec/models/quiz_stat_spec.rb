require_relative '../spec_helper'

describe QuizStat do
  before :each do
    @quiz_stat = create :quiz_stat
    @answer = create :problemanswer
  end

  describe "#update!" do
    it "should decrement the remaining problems" do
      remaining = @quiz_stat.remaining
      @quiz_stat.update!(@answer)
      remaining.should == (@quiz_stat.remaining - 1)
    end

    it "should destroy the quiz_stat if 0 are remaining" do
      pending
    end
  end
end
