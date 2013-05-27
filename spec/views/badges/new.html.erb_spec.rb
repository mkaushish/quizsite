require 'spec_helper'

describe "badges/new" do
  before(:each) do
    assign(:badge, stub_model(Badge).as_new_record)
  end

  it "renders new badge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => badges_path, :method => "post" do
    end
  end
end
