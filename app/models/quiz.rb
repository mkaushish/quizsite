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

  belongs_to  :identifiable, :polymorphic => true;
  attr_accessible :name
  attr_accessible :problemtypes
  attr_accessible :identifiable

  validates :problemtypes, :presence => true

  validates :identifiable_id,   :presence => true

  validates :name,         :presence => true,
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
