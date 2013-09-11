require 'spec_helper'

describe "topics/edit" do
  before(:each) do
    @topic = assign(:topic, stub_model(Topic,
      :content => "MyText",
      :user_id => 1,
      :classroom_id => 1,
      :comments_count => 1
    ))
  end

  it "renders the edit topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", topic_path(@topic), "post" do
      assert_select "textarea#topic_content[name=?]", "topic[content]"
      assert_select "input#topic_user_id[name=?]", "topic[user_id]"
      assert_select "input#topic_classroom_id[name=?]", "topic[classroom_id]"
      assert_select "input#topic_comments_count[name=?]", "topic[comments_count]"
    end
  end
end
