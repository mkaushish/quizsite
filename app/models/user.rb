# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string
#  email              :string
#  perms              :string
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string
#  salt               :string
#

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

require 'digest'
require 'grade6'

class User < ActiveRecord::Base
  @@email_regex = /^[\w0-9+.!#\$%&'*+\-\/=?^_`{|}~]+@[a-z0-9\-]+(:?\.[0-9a-z\-]+)+$/i

  attr_accessor :password
  attr_accessible :email, :name, :password, :password_confirmation

  has_many :problemanswers, :dependent => :destroy
  has_many :quiz_users
  has_many :quizzes, :through => :quiz_users

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  validates :email, :presence => true,
                    :format => { :with => @@email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  before_save  :encrypt_password
  before_create :generate_confirmation_code

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end

  # the cookie stores both the userid and the salt, so if the user changes his password (and therefore salt), (s)he can
  # reset his cookie as well
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def smartScore(ptype)
    # TODO implement smartscore + calculations for real
    return "?" if problemanswers.where(:pclass => ptype.to_s).length == 0
    return (problemanswers.where(:correct => true, :pclass => ptype.to_s).length*100)/problemanswers.where(:pclass => ptype.to_s).length
  end

  def generate_confirmation_code
    # TODO generate confirmation code in a more secure way? necessary?
    # rand is prob like 10 digits, + Time.now gives us a fair amount of security... I hope
    self.confirmation_code = secure_hash "#{Time.now.utc}--#{rand}"
  end

  def confiramtion_code()
    self.confiramtion_code ||= new_code
  end


  def confirm(code)
    if self.confirmation_code == code
      return self.confirmed = true
    end
    false
  end

  def confirmed?
    return self.confirmed
  end

  private

  def encrypt_password
    self.salt = make_salt unless has_password?(password)
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash "#{salt}--#{string}"
  end

  def make_salt
    secure_hash "#{Time.now.utc}--#{password}"
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def default_values
    self.confirmed ||= false
  end
end
