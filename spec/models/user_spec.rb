# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  perms              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require_relative '../spec_helper'

describe User do
  before :each do
    @attr = {
      :name => "Thomas Ramfjord",
      :email => "myfakeemail@blah.com",
      :password => "blah123",
      :password_confirmation => "blah123"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name, but not too long of one" do
    failuser = User.new(@attr.merge(:name => "")) 
    failuser.should_not be_valid
    failuser = User.new(@attr.merge(:name => "#"*51)) 
    failuser.should_not be_valid
  end

  it "should accept reasonably valid emails" do
    goodaddresses = %w[user+blah@foo.com THE_USER@foo.bar.org first.last@foo.jp]  
    goodaddresses.each do |address|
      user = User.new(@attr.merge(:email => address)) 
      user.should be_valid
    end
  end

  it "should reject clearly invalid emails" do
    badaddresses = %w(2@s@blah.com ihavnoat.blah no@domaindot required@after.)
    badaddresses << ""
    badaddresses.each do |badaddress|
      failuser = User.new(@attr.merge(:email => badaddress)) 
      failuser.should_not be_valid
    end
  end

  it "should reject duplicate emails, even if they have different casing" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before :each do
      @user = User.create!(@attr)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
    end

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end
end
