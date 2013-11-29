require 'spec_helper'

describe "lessons/edit" do
  before(:each) do
    @lesson = assign(:lesson, stub_model(Lesson,
      :classroom_id => 1,
      :teacher_id => 1
    ))
  end

  it "renders the edit lesson form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", lesson_path(@lesson), "post" do
      assert_select "input#lesson_classroom_id[name=?]", "lesson[classroom_id]"
      assert_select "input#lesson_teacher_id[name=?]", "lesson[teacher_id]"
    end
  end
end
