require 'spec_helper'

describe "topics/index" do
  before(:each) do
    assign(:topics, [
      stub_model(Topic,
        :content => "MyText",
        :user_id => 1,
        :classroom_id => 2,
        :comments_count => 3
      ),
      stub_model(Topic,
        :content => "MyText",
        :user_id => 1,
        :classroom_id => 2,
        :comments_count => 3
      )
    ])
  end

  it "renders a list of topics" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
