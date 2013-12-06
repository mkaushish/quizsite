require 'spec_helper'

describe "Problemanswers" do
  describe "GET /problemanswers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get problemanswers_path
      response.status.should be(200)
    end
  end
end
