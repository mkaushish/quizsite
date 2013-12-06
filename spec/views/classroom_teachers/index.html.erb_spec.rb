require 'spec_helper'

describe "classroom_teachers/index" do
  before(:each) do
    assign(:classroom_teachers, [
      stub_model(ClassroomTeacher,
        :classroom_id => 1,
        :teacher_id => 2
      ),
      stub_model(ClassroomTeacher,
        :classroom_id => 1,
        :teacher_id => 2
      )
    ])
  end

  it "renders a list of classroom_teachers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
