class Quiz < ActiveRecord::Base
  
  has_many :quiz_instances, :dependent => :destroy
  has_many :users, :through => :quiz_instances
  has_many :quiz_problems, inverse_of: :quiz, :dependent => :destroy

  has_many :classroom_quizzes, :dependent => :destroy
  has_many :problem_types, :through => :problem_set

  belongs_to :classroom
  belongs_to :problem_set

  belongs_to :teacher

  accepts_nested_attributes_for :quiz_problems

  attr_accessible :name, :problem_set_id, :start_time, :end_time, :limit, :timer, :quiz_type

  QUIZ_TYPES = { 1 => "Back and Forth", 2 => "Timed without Back and Forth" }

  def quiztype
    QUIZ_TYPES[quiz_type]
  end

  def self.quiz_type_array
    QUIZ_TYPES.to_a.sort
  end

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
        "remaining" => qp.count,
        "problem_id" => qp.problem_id
      }
    end
  end

  def for_user(user)
    quiz_instances.where(:user_id => user.id).first
  end

  def for_class(klass)
    @class_quizzes ||= {}
    @class_quizzes[klass] ||= classroom_quizzes.where(classroom_id:klass.id).first
    @class_quizzes[klass] || classroom_quizzes.new(classroom_id:klass.id)
  end

  def default_problems
    problem_set.problem_types.map do |ptype|
      quiz_problems.new(problem_type: ptype, count: 1)
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

  # psi = a ProblemSetInstance
  def assign_with_pset_inst(problem_set_instance)
    instance = quiz_instances.build(:user_id => problem_set_instance.user_id, :problem_set_instance => problem_set_instance)
    instance.remaining_time = self.timer.hour * 60 * 60 + self.timer.min * 60 +  self.timer.sec if self.quiz_type == 2 
    return nil unless instance.save # if they already have an instance of this problem set it won't work
    instance
  end

  def assign(user)
    instance = quiz_instances.build(:user_id => user.id)
    return nil unless instance.save # if they already have an instance of this problem set it won't work
  end

  def validate_quiz_instance(problem_set_instance)
    instance = self.quiz_instances.where(:problem_set_instance_id => problem_set_instance).last
    instance ||= self.assign_with_pset_inst(problem_set_instance)
    return instance
  end

  def assign_classroom(classroom)
    class_quiz = self.for_class classroom
    class_quiz.save
  end

  def assign_classrooms(classroom_ids)
    classroom_ids.each do |classroom_id|
      classroom = Classroom.find_by_id(classroom_id)
      class_quiz = self.for_class classroom
      class_quiz.save
    end
  end

  def assign_students(student_ids, classroom_id)
    self.students = student_ids
    self.save
    classroom = Classroom.find_by_id(classroom_id)
    class_quiz = self.for_class classroom
    class_quiz.save
  end
end