require 'spec_helper'

describe "problemanswers/new.html.erb" do
  before(:each) do
    assign(:problemanswer, stub_model(Problemanswer,
      :correct => false,
      :problem_id => 1
    ).as_new_record)
  end

  it "renders new problemanswer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => problemanswers_path, :method => "post" do
      assert_select "input#problemanswer_correct", :name => "problemanswer[correct]"
      assert_select "input#problemanswer_problem_id", :name => "problemanswer[problem_id]"
    end
  end
end
