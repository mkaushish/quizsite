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
  has_many :classroom_quizzes
  has_many   :problem_types, :through => :problem_set

  belongs_to :classroom
  belongs_to :problem_set

  accepts_nested_attributes_for :quiz_problems

  def Quiz.history_classroom(klass)
    psets = klass.problem_sets
    where(problem_set_id: psets.map(&:id)).includes(:classroom_quizzes)
  end

  def Quiz.history_problem_set(pset)
    where(problem_set_id: pset).includes(:classroom_quizzes)
  end

  def stat_attrs
    @stat_attrs = quiz_problems.map do |qp|
      {
        "problem_type_id" => qp.problem_type_id,
        "remaining" => qp.count
      }
    end
  end

  def for_class(klass)
    @class_quizzes ||= {}
    @class_quizzes[klass] ||= classroom_quizzes.where(classroom_id:klass.id).first
    @class_quizzes[klass] || classroom_quizzes.new(classroom_id:klass.id)
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

  def idname
    return "quiz_#{self.id}"
  end

  def ptypes
    @ptypes ||= Marshal.load(self.problemtypes)
  end

  def assign(user)
    instance = quiz_instances.build(:user_id => user.id)
    return nil unless instance.save # if they already have an instance of this problem set it won't work
  end
end
