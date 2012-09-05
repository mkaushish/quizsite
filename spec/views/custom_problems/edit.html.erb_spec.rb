require 'spec_helper'

describe "custom_problems/edit.html.erb" do
  before(:each) do
    @custom_problem = assign(:custom_problem, stub_model(CustomProblem,
      :problem => "MyText",
      :owner_id => 1,
      :chapter => "MyString"
    ))
  end

  it "renders the edit custom_problem form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => custom_problems_path(@custom_problem), :method => "post" do
      assert_select "textarea#custom_problem_problem", :name => "custom_problem[problem]"
      assert_select "input#custom_problem_owner_id", :name => "custom_problem[owner_id]"
      assert_select "input#custom_problem_chapter", :name => "custom_problem[chapter]"
    end
  end
end
