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
  has_many :quiz_instances
  has_many :users, :through => :quiz_instances

  has_many :quiz_problems, inverse_of: :quiz, dependent: :destroy
  has_many :problem_types, :through => :quiz_problems

  belongs_to :classroom
  belongs_to :problem_set

  accepts_nested_attributes_for :quiz_problems

  def assign(start_time, end_time)
    self.starts_at = start_time
    self.ends_at = start_time
  end

  def default_problems
    problem_set.problem_types.map do |ptype|
      quiz_problems.new(problem_type: ptype, count: 2)
    end
  end

  def add_problem_type(problem_type, count)
    !problem_type.nil? && quiz_problem_types.create(:problem_type => problem_type)
  end

  def remove_problem_type(problem_type)
    !problem_type.nil? && quiz_problem_types.where(:problem_type => problem_type).first.delete
  end

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

  def smart_score
    return "?"
  end

  def allow_access(user)
    quiz_users.create!(:user => user)
  end

  def set_problem_orders
    quiz_users.each do |qu|
      qu.set_problem_order ptypes
    end
  end
end
