require 'spec_helper'

describe "classroom_teachers/show" do
  before(:each) do
    @classroom_teacher = assign(:classroom_teacher, stub_model(ClassroomTeacher,
      :classroom_id => 1,
      :teacher_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
