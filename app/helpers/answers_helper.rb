#require 'tohtml'
include ToHTML

module AnswersHelper
  attr_accessor :solution, :response

  def correct?(htmlobj)
    htmlobj.correct? @solution, @response
  end

  def ans_correct?
    @answer.correct unless @answer.nil?
    @correct
  end

  # Takes as input the solution hash from problem.solve, and the InputField,
  # and returns the solution associated with said field in string form
  def field_soln(solnhash, field)
    solnhash[ToHTML::rm_prefix(field.name)].to_s
  end

  def correct_class(answer)
    (answer.correct) ? "correct" : "incorrect"
  end
end
