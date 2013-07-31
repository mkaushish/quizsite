require 'spec_helper'

describe "ClassroomTeachers" do
  describe "GET /classroom_teachers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get classroom_teachers_path
      response.status.should be(200)
    end
  end
end
