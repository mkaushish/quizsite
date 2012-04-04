# == Schema Information
#
# Table name: quizzes
#
#  id           :integer         not null, primary key
#  problemtypes :binary
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Quiz < ActiveRecord::Base
  belongs_to :user

  #before_save :dump_problemtypes

  validates :problemtypes, :presence => true;
  validates :user_id,      :presence => true;

  # need to call me if problemtypes has been altered
  #def dump_problemtypes
  #  unless @ptypes.nil? || self.response != nil
  #    self.problemtypes = Marshal.dump(@ptypes) 
  #    @ptypes = nil
  #  end
  #end

  def ptypes
    @ptypes ||= Marshal.load(self.problemtypes)
  end
end
