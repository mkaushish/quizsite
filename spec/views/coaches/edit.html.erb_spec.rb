require 'spec_helper'

describe "coaches/edit" do
  before(:each) do
    @coach = assign(:coach, stub_model(Coach,
      :name => "MyString",
      :relation => "MyString"
    ))
  end

  it "renders the edit coach form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", coach_path(@coach), "post" do
      assert_select "input#coach_name[name=?]", "coach[name]"
      assert_select "input#coach_relation[name=?]", "coach[relation]"
    end
  end
end
