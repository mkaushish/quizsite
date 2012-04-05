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
  belongs_to :user

  attr_accessible :name
  attr_accessible :problemtypes

  validates :problemtypes, :presence => true
  validates :user_id,      :presence => true
  validates :name,         :presence => true,
                           :length => { :maximum => 20 }

  def ptypes
    @ptypes ||= Marshal.load(self.problemtypes)
  end
end
