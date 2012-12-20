require 'spec_helper'
require 'grade6'
require_relative '../login.rb'

describe QuizzesController do

  describe "for non-logged in users: " do

    describe "GET new, edit" do
      it "should redirect to the home page" do
        get 'new'
        response.should redirect_to(root_path)
      end
    end
  end

  describe "for students: " do
    before(:each) do
      @student = nil
      login_as @student
    end
  end

  describe "for teachers: " do
    before(:each) do
      @teacher = Teacher.find_by_email "t.homasramfjord@gmail.com"
      login_as @teacher
    end

    describe "GET new, edit" do
      it "should be a success" do
        get '/new'
        response.should be_success

        # get '/edit'
        # response.should be_success
      end

      it "should have an option for adding custom problem types" do
      end
    end

    describe "CREATE, UPDATE" do
      describe "should render errors when" do
        before(:each) do
        end

        it "name is invalid" do
        end
      end

      describe "when valid" do
        it "should assign the correct quiz_problem_types" do
        end

        it "should assign the correct user" do
        end

        it "should assign the correct name" do
        end

        it "should redirect_to profile_path" do
        end
      end
    end
  end
end
