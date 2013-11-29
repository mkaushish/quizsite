require 'spec_helper'

describe "problemanswers/show.html.erb" do
  before(:each) do
    @problemanswer = assign(:problemanswer, stub_model(Problemanswer,
      :correct => false,
      :problem_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
