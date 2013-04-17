# A ProblemGenerator spawns a problem for a student to do
# Currently each problem type has both
#   a smartergrades problem generator for QuestionBase generated questions
#   a custom question generator for user input questions
#
# Consists of
#   int     problem_type_id
#   string  klass  # null and unnecessary for custom QGs
#
class ProblemGenerator < ActiveRecord::Base
  has_many  :problems
  has_many  :answers

  belongs_to :problem_type
  validates  :problem_type, :presence => true

  def spawn(*args)
    if custom?
      problems[rand(problems.length)]
    else
      return self.problems.create(:problem => klass.constantize.new(*args))
    end
  end

  def custom?
    self.klass.nil?
  end
end
