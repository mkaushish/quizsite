require 'spec_helper'

describe "comments/new" do
  before(:each) do
    assign(:comment, stub_model(Comment,
      :content => "MyString",
      :user_id => 1,
      :answer_id => 1,
      :classroom_id => 1
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", comments_path, "post" do
      assert_select "input#comment_content[name=?]", "comment[content]"
      assert_select "input#comment_user_id[name=?]", "comment[user_id]"
      assert_select "input#comment_answer_id[name=?]", "comment[answer_id]"
      assert_select "input#comment_classroom_id[name=?]", "comment[classroom_id]"
    end
  end
end
