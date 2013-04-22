# ATTRIBUTES:
#   name: in our case often "N: Chapter name"
#   user_id: nil for the default problem sets, teacher_id for those created by teachers
class ProblemSet < ActiveRecord::Base
  attr_reader :ptype_params # used in initialization

  attr_accessible :name, :ptype_params
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :problem_set_problems
  has_many :problem_types, :through => :problem_set_problems

  has_many :problem_set_instances
  has_many :users, :through => :problem_set_instances

  has_many :classroom_problem_sets
  has_many :classrooms, :through => :classroom_problem_sets

  has_many :quizzes
  accepts_nested_attributes_for :problem_set_problems, :allow_destroy => true

  before_validation :parse_ptype_params

  def assign(user)
    instance = problem_set_instances.build(:user_id => user.id)
    return nil unless instance.save # if they already have an instance of this problem set it won't work
  end

  def self.master_sets
    ProblemSet.where("user_id IS NULL")
  end

  def self.master_sets_with_ptypes
    ProblemSet.where("user_id IS NULL").includes("problem_types")
  end

  def idname
    return "problem_set_#{self.id}"
  end

  def ptypes_hash
    @ptypes_hash ||= Hash[ problem_set_problems.to_a.map { |e| [e.problem_type_id, e] } ]
  end

  def clone_for(user)
    user.problem_set.new(name: name)
  end

  def add_problem_type(problem_types)
    ptypes_hash[problem_type.id] ||= self.problem_set_problems.new(problem_type: problem_type)
  end

  def del_problem_type!(problem_type)
    ptyps_hash[problem_type.id].delete if ptypes_hash[problem_type.id]
    ptyps_hash[problem_type.id] = nil
  end

  private

    def parse_ptype_params
      if @ptype_params && problem_types.empty?
        self.problem_types = ProblemType.where(id: @ptype_params.keys)
      end
      self
    end
end
