require 'spec_helper'

describe "custom_problems/show.html.erb" do
  before(:each) do
    @custom_problem = assign(:custom_problem, stub_model(CustomProblem,
      :problem => "MyText",
      :owner_id => 1,
      :chapter => "Chapter"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Chapter/)
  end
end
