# ATTRIBUTES:
#   name: in our case often "N: Chapter name"
#   user_id: nil for the default problem sets, teacher_id for those created by teachers
class ProblemSet < ActiveRecord::Base
  has_many :problem_set_problems
  has_many :problem_types, :through => :problem_set_problems

  has_many :problem_set_instances
  has_many :users, :through => :problem_set_instances

  has_many :classrooms_problem_sets
  has_many :classrooms, :through => :classrooms_problem_sets

  accepts_nested_attributes_for :problem_set_problems

  def assign(user)
    instance = problem_set_instances.build(:user_id => user.id)
    return false unless instance.save # if they already have an instance of this problem set it won't work
  end

  def idname
    return "problem_set_#{self.id}"
  end

  # def problems
  #   @problems ||= Hash[ self.problem_types.map { |p| [p.name, p] } ]
  # end

  # def includes_by_name?(name)
  #   problems[name].nil?
  # end

  # def add_problem(

  # end
end
