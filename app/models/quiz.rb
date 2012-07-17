# == Schema Information
#
# Table name: quizzes
#
#  id           :integer         not null, primary key
#  problemtypes :binary
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string
#

class Quiz < ActiveRecord::Base
  @@name_regex = /[a-zA-Z0-9 ]+/

  attr_accessible :name, :problemtypes

  validates :problemtypes, :presence => true

  validates :name,         :presence => true,
                           :uniqueness => { :scope => :user_id, :message => "You can't name two homeworks the same thing" },
                           :length => { :within => 1..20 },
                           :format => { :with => @@name_regex, :message => "Only letters and numbers allowed" }

  def ptypes
    @ptypes ||= Marshal.load(self.problemtypes)
  end

  def idname
    return "quiz_#{self.id}"
  end

  # TODO implement thse two
  def hasSmartScore?
    return false
  end

  def smartScore
    return "?"
  end
end
