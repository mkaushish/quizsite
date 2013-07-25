require 'spec_helper'

describe "classroom_teachers/edit" do
  before(:each) do
    @classroom_teacher = assign(:classroom_teacher, stub_model(ClassroomTeacher,
      :classroom_id => 1,
      :teacher_id => 1
    ))
  end

  it "renders the edit classroom_teacher form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", classroom_teacher_path(@classroom_teacher), "post" do
      assert_select "input#classroom_teacher_classroom_id[name=?]", "classroom_teacher[classroom_id]"
      assert_select "input#classroom_teacher_teacher_id[name=?]", "classroom_teacher[teacher_id]"
    end
  end
end
