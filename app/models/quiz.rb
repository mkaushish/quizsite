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
  before_save :dump_problemtypes

  validates :problemtypes, :presence => true;

  # need to call me if problemtypes has been altered
  def dump_problemtypes
    unless @problemtypes.nil?
      self.problemtypes = Marshal.dump(@problemtypes) 
      @problemtypes = nil
    end
  end

  def problemtypes
    load_problemtypes if @problemtypes.nil?
    @problemtypes
  end

  private

  def load_problemtypes
    @problemtypes = Marshal.load(self.problemtypes)
  end
end
