class ProblemType < ActiveRecord::Base
  attr_accessible :name, :klass, :problem, :description, :video_link
  belongs_to :user # possibly smartergrades

  # these shouldn't actually ever be destroyed
  # if they are, then the problems/answers for them will all be broken,
  # - they could be fixed with a rake task though
  has_many :problem_generators # usually 1 smartergrades, + any custom added
  has_many :problems, :through => :problem_generators #, :dependent => :destroy
  has_many :answers, :through => :problem_generators #, :dependent => :destroy
  has_many :user_stats
  has_many :problem_stats
  # shouldn't need to reference quizzes from this end though
  has_many :quiz_problems
  has_many :problem_set_problems

  validates :name, :presence => true

  def spawn_problem(*args)
    # currently just do the smartergrades problems
    problem_generators.first.spawn(*args)
  end

  def to_s() self.name.truncate(43) ; end

  def smartergrades_generator
    problem_generators.each { |g| return g if !g.klass.nil? }
    nil
  end

  def custom_problems_generator
    problem_generators.each { |g| return g if g.klass.nil? }
    nil
  end
  
  def total_correct_wrong_problem_type_answers
    answers = self.answers_correct
    correct_answers = answers.select{|v| v == true }.count 
    wrong_answers = answers.select{|v| v == false }.count 
    total_answers = answers.count 
    return [total_answers, correct_answers, wrong_answers]     
  end

  def answers_correct
    self.answers.pluck(:correct)
  end

  def student_answers_correct(student)
    self.answers.where("user_id = ?", student).pluck(:correct)
  end
end