require 'spec_helper'

describe "classroom_teachers/new" do
  before(:each) do
    assign(:classroom_teacher, stub_model(ClassroomTeacher,
      :classroom_id => 1,
      :teacher_id => 1
    ).as_new_record)
  end

  it "renders new classroom_teacher form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", classroom_teachers_path, "post" do
      assert_select "input#classroom_teacher_classroom_id[name=?]", "classroom_teacher[classroom_id]"
      assert_select "input#classroom_teacher_teacher_id[name=?]", "classroom_teacher[teacher_id]"
    end
  end
end
