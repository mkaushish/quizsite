class ProblemType < ActiveRecord::Base
  attr_accessible :name, :klass, :problem
  belongs_to :user # possibly smartergrades

  # these shouldn't actually ever be destroyed
  # if they are, then the problems/answers for them will all be broken,
  # - they could be fixed with a rake task though
  has_many :problem_generators # usually 1 smartergrades, + any custom added
  has_many :problems,       :through => :problem_generators #, :dependent => :destroy
  has_many :problemanswers, :through => :problem_generators #, :dependent => :destroy
  has_many :user_stats

  # shouldn't need to reference quizzes from this end though
  has_many :quiz_problems
  has_many :problem_set_problems

  validates :name, :presence => true

  def spawn(*args)
    # currently just do the smartergrades problems
    self.problem_generators.first.spawn(*args)
  end

  def to_s() self.name ; end
end
