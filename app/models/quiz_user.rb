class QuizUser < ActiveRecord::Base
  attr_writer :problem_order
  attr_accessible :quiz_id, :user_id, :problem_order
  belongs_to :quiz
  belongs_to :user

  before_save :dump_problem_order

  def problem_order
    @problem_order ||= Marshal.load(self.s_problem_order)
  end

  def reset_problem_order
    @problem_order = quiz.ptypes.shuffle
  end

  def dump_problem_order
    self.s_problem_order = Marshal.dump(@problem_order) if @problem_order.is_a? Array
  end

  def next_problem
    if self.problem_id == -1
      reset_problem_order if problem_order.empty?

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

    # increment if we've had over 2 attempts, or if we get it right
    if last_correct || self.num_attempts >= 2
      self.num_attempts = 0
      problem_order.shift
    end

    # either way gen a new problem
    self.problem_id = -1

    save
  end
end
