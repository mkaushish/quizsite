class ProblemGenerator < ActiveRecord::Base
  attr_reader :custom_problem

  belongs_to :problem_type
  has_many :problems

  validates :problem_type, :presence => true

  # If the generator is for a custom problem, only have one problem, and NO KLASS HERE 
  # (can still find which CustomProblemType from self.problems.first, but won't ever need it anyway)
  # Elsif it's for QuestionBase problems, klass name must be there, and we generate a new one every time
  # validates :klass, :presence => true, :unless => :custom?


  # Generate the custom problems if necessary
  before_create { raise "you need to supply the Problem for custom ProblemGenerators" if(klass.nil? && !(@custom_problem < CustomProblem)) }
  after_create  { self.problems.create(:problem => @custom_problem) if klass.nil? }

  def spawn(*args)
    if custom?
      return self.problems.first
    else
      return self.problems.create(:problem => klass.constantize.new(*args))
    end
  end

  def custom?
    self.klass.nil?
  end
end
