class QuizUser < ActiveRecord::Base
  attr_writer :problem_order
  attr_accessible :quiz_id, :user_id, :quiz, :user, :problem_order
  belongs_to :quiz
  belongs_to :user

  validates :quiz_id, :presence => true
  validates :user_id, :presence => true

  before_save :dump_problem_order

  def problem_order
    begin
      @problem_order ||= Marshal.load(self.s_problem_order)
      reset_problem_order if @problem_order.nil?
      @problem_order
    rescue
      reset_problem_order
      $stderr.puts "PROBLEM ORDER HAD TO BE RESCUED AGAIN???"
      @problem_order
    end
  end

  def reset_problem_order
    @problem_order = quiz.ptypes.shuffle
    dump_problem_order
    save
  end

  def dump_problem_order
    self.s_problem_order = Marshal.dump(@problem_order) # if @problem_order.is_a? Array
  end

  def next_problem
    if self.problem_id == -1
      reset_problem_order if problem_order.empty?

      ptype = problem_order[0]
      p = Problem.new
      p.my_initialize ptype
      p.save
      self.problem_id = p.id

      # TODO, is this really necessary?
      dump_problem_order
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
