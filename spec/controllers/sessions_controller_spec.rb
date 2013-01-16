#Copyright (c) 2010 Michael Hartl
#
#   Permission is hereby granted, free of charge, to any person
#   obtaining a copy of this software and associated documentation
#   files (the "Software"), to deal in the Software without
#   restriction, including without limitation the rights to use,
#   copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the
#   Software is furnished to do so, subject to the following
#   conditions:
#
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#   OTHER DEALINGS IN THE SOFTWARE.
#/*
# * ------------------------------------------------------------
# * "THE BEERWARE LICENSE" (Revision 42):
# * Michael Hartl wrote this code. As long as you retain this 
# * notice, you can do whatever you want with this stuff. If we
# * meet someday, and you think this stuff is worth it, you can
# * buy me a beer in return.
# * ------------------------------------------------------------
# */
require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do

    describe "invalid signin" do
      it "should return an http status 422" do
        post :create, :session => { :email => generate(:email), :password => "password12345" }
        response.response_code.should == 422
      end

      describe "where user exists" do
        it "should tell them their password is wrong" do
          user = create(:student)
          post :create, :session => { email: user.email, password: "wrong_password1" }
          response.should render_template(:js => 'wrong_password')
        end
      end

      describe "where email's not taken" do
        it "should ask them if they want to register" do
          post :create, :session => { :email => "hello@yourmom.com", :password => "password12345" } 
          response.should render_template('register')
        end
      end
    end

    describe "with valid email and password" do

       before(:each) do
         @user = create(:student)
         @attr = { :email => @user.email, :password => @user.password }
       end

       it "should sign the user in" do
         post :create, :session => @attr
         controller.current_user.should == @user
         controller.should be_signed_in
       end

       # these two won't work without more high level testing since we ajaxed.
       # capybara could help
       it "should redirect Students to their home page" do
         user = create :student
         post :create, :session => { email: user.email, password: user.password }
         # response.should redirect_to(profile_path(student))
       end

       it "should redirect Teachers correctly" do
         # post :create, :session => @attr
         # response.should redirect_to(user_path(@user))
       end
     end 
  end

  describe "DELETE 'destroy'" do
    it "should sign a user out" do
      test_sign_in(FactoryGirl.create(:student))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end
