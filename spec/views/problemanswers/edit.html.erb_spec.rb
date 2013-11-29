require 'spec_helper'

describe "problemanswers/edit.html.erb" do
  before(:each) do
    @problemanswer = assign(:problemanswer, stub_model(Problemanswer,
      :correct => false,
      :problem_id => 1
    ))
  end

  it "renders the edit problemanswer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => problemanswers_path(@problemanswer), :method => "post" do
      assert_select "input#problemanswer_correct", :name => "problemanswer[correct]"
      assert_select "input#problemanswer_problem_id", :name => "problemanswer[problem_id]"
    end
  end
end
