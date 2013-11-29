require 'spec_helper'

describe ProblemController do

  describe "GET 'choose'" do
    it "should be successful" do
      get 'choose'
      response.should be_success
    end
  end

end
