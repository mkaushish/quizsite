class QuizUser < ActiveRecord::Base
  attr_writer :problem_order
  attr_accessible :quiz_id, :user_id, :quiz, :user, :problem_order
  belongs_to :quiz
  belongs_to :user

  validates :quiz_id, :presence => true
  validates :user_id, :presence => true

  before_save   :dump_problem_order

  def dump_problem_order
    self.s_problem_order = Marshal.dump(@problem_order) unless @problem_order.nil?
  end

  def problem_order
    begin
      @problem_order ||= Marshal.load(self.s_problem_order)
    rescue
    end
    reset_problem_order unless (@problem_order.is_a?(Array) && (!@problem_order.empty?))
    @problem_order
  end

  def set_problem_order(problem_order)
    self.problem_id = -1
    self.num_attempts = 0
    @problem_order = problem_order
    save
  end

  def reset_problem_order
    set_problem_order quiz.ptypes.shuffle
  end

  def next_problem
    if self.problem_id == -1
      ptype = problem_order[0]
      p = Problem.new
      p.my_initialize ptype
      p.save

      self.problem_id = p.id
      save
      p
    else
      Problem.find(self.problem_id)
    end
  end

  def increment_problem(last_correct)
    self.num_attempts += 1

    # either way gen a new problem
    self.problem_id = -1 unless force_explanation? && !last_correct

    # increment if we get it right, or if we just went through the explanation
    if last_correct
      self.num_attempts = 0
      problem_order.shift
      @problem_order = quiz.ptypes.shuffle if problem_order.empty?
    end

    save
  end

  def force_explanation?
    self.num_attempts >= 2 && self.problem_id > 0
  end
end
