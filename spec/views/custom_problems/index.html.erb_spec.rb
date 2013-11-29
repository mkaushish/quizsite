require 'spec_helper'

describe "custom_problems/index.html.erb" do
  before(:each) do
    assign(:custom_problems, [
      stub_model(CustomProblem,
        :problem => "MyText",
        :owner_id => 1,
        :chapter => "Chapter"
      ),
      stub_model(CustomProblem,
        :problem => "MyText",
        :owner_id => 1,
        :chapter => "Chapter"
      )
    ])
  end

  it "renders a list of custom_problems" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Chapter".to_s, :count => 2
  end
end
