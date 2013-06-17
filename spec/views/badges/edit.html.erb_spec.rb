require 'spec_helper'

describe "badges/edit" do
  before(:each) do
    @badge = assign(:badge, stub_model(Badge))
  end

  it "renders the edit badge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => badges_path(@badge), :method => "post" do
    end
  end
end
