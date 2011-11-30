# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  perms      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require_relative '../spec_helper'

describe User do
	before :each do
		@attr = {
      :name => "Thomas Ramfjord",
      :email => "myfakeemail@blah.com",
      :password => "blah123"
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
end
