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

class User < ActiveRecord::Base
  attr_accessible :email
  attr_accessible :name

  @@email_regex = /^[\w+.!#\$%&'*+\-\/=?^_`{|}~]+@[a-z\-]+(:?\.[a-z\-]+)+$/i

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  validates :email, :presence => true,
                    :format => { :with => @@email_regex },
                    :uniqueness => { :case_sensitive => false }
end
