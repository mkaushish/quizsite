require 'spec_helper'

describe "relationships/index" do
  before(:each) do
    assign(:relationships, [
      stub_model(Relationship,
        :coach_id => 1,
        :student_id => 2
      ),
      stub_model(Relationship,
        :coach_id => 1,
        :student_id => 2
      )
    ])
  end

  it "renders a list of relationships" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
