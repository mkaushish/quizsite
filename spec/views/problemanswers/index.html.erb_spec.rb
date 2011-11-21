require 'spec_helper'

describe "problemanswers/index.html.erb" do
  before(:each) do
    assign(:problemanswers, [
      stub_model(Problemanswer,
        :correct => false,
        :problem_id => 1
      ),
      stub_model(Problemanswer,
        :correct => false,
        :problem_id => 1
      )
    ])
  end

  it "renders a list of problemanswers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
