require 'spec_helper'

describe "badges/index" do
  before(:each) do
    assign(:badges, [
      stub_model(Badge),
      stub_model(Badge)
    ])
  end

  it "renders a list of badges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
