require_relative '../../grade6/myc12.rb'
require_relative '../../modules/items.rb'

include MyChapter12
describe "Chapter 12: " do
  before(:each) do
  end

  describe "What's a ratio: " do
    before(:each) do
      @a, @b = 21, 9
      @i, @j = 250000, 50000
      @n, @m = 25, 75

      @p_ab = DefRatio.new(@a, @b)
      @p_ij = DefRatio.new(@i, @j)
      @p_nm = DefRatio.new(@n, @m)
    end

    it 'solve should return the reduced ratio' do
      @p_ab.solve["n"].should == 7
      @p_ab.solve["m"].should == 3
      @p_ij.solve["n"].should == 5
      @p_ij.solve["m"].should == 1
      @p_nm.solve["n"].should == 1
      @p_nm.solve["m"].should == 3
    end

    it 'correct should return true given the reduced ratio' do
      @p_ab.correct?(@p_ab.prefix_solve).should be_true
      @p_ij.correct?(@p_ij.prefix_solve).should be_true
      @p_nm.correct?(@p_nm.prefix_solve).should be_true
    end

    it 'correct should return true given the unreduced ratio' do
      @p_ab.correct?("qbans_n" => @a, "qbans_m" => @b).should be_true
      @p_ij.correct?("qbans_n" => @i, "qbans_m" => @j).should be_true
      @p_nm.correct?("qbans_n" => @n, "qbans_m" => @m).should be_true
    end

    it 'correct should return false for wrong answers' do
      @p_ab.correct?("qbans_n" => 1, "qbans_m" => 1).should be_false
      @p_ij.correct?("qbans_n" => 0, "qbans_m" => 2).should be_false
      @p_nm.correct?("qbans_n" => 5, "qbans_m" => 3).should be_false
    end
  end
end

