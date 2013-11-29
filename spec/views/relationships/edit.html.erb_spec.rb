require 'spec_helper'

describe "relationships/edit" do
  before(:each) do
    @relationship = assign(:relationship, stub_model(Relationship,
      :coach_id => 1,
      :student_id => 1
    ))
  end

  it "renders the edit relationship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", relationship_path(@relationship), "post" do
      assert_select "input#relationship_coach_id[name=?]", "relationship[coach_id]"
      assert_select "input#relationship_student_id[name=?]", "relationship[student_id]"
    end
  end
end
