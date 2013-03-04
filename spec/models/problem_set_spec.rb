require_relative '../spec_helper'

describe ProblemSet do
  before :each do
  end

  it "should enforce a unique user_id/name combo" do
  end

  describe "parse_ptype_params" do
    it "should set ptypes based on a hash with keys of problem_type_ids" do
    end
  end

  describe "clone" do
    before(:each) do
      @pset = FactoryGirl.create(:full_problem_set)
    end

    it "should have the same problem_types" do
    end
    it "should have none of the same problem set problems" do
    end
  end
end
