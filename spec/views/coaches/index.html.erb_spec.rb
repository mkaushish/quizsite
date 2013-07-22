require 'spec_helper'

describe "coaches/index" do
  before(:each) do
    assign(:coaches, [
      stub_model(Coach,
        :name => "Name",
        :relation => "Relation"
      ),
      stub_model(Coach,
        :name => "Name",
        :relation => "Relation"
      )
    ])
  end

  it "renders a list of coaches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Relation".to_s, :count => 2
  end
end
