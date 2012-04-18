# == Schema Information
#
# Table name: problemanswers
#
#  id         :integer         not null, primary key
#  correct    :boolean
#  problem_id :integer
#  created_at :datetime
#  updated_at :datetime
#  response   :string
#  user_id    :integer
#  type       :string
#

require 'spec_helper'

describe Problemanswer do
  before :each do
    @user = Factory(:user)
    @attr = {
      :problem_id => 1, 
      :correct => true, 
      :response => Marshal.dump({"ans" => "35"})
    }
  end

  it "should create a new instance given valid attributes" do
    @user.problemanswers.create!(@attr)
  end

  describe "user associations" do
    before :each do
      @probans = @user.problemanswers.create!(@attr)
    end

    it "should have a user attribute" do
      @probans.should respond_to(:user)
    end

    it "should have the correct associated user" do
      @probans.user.should == @user
      @probans.user_id.should == @user.id
    end
  end
end
