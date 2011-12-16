require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'show'" do

    before :each do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
  end

  describe "authentication of show" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed in users" do
      # TODO - show public profile page?
      it "should deny access to show when not signed in" do
        get :show, :id => @user
      end
    end
  end
end
