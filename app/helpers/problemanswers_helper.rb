#require 'tohtml'
include ToHTML

module ProblemanswersHelper
  attr_accessor :solution, :response

  def correct?(htmlobj)
    htmlobj.correct? @solution, @response
  end

  # Takes as input the solution hash from problem.solve, and the InputField,
  # and returns the solution associated with said field in string form
  def field_soln(solnhash, field)
    solnhash[ToHTML::rm_prefix(field.name)].to_s
  end

  def correct_class(problemanswer)
    (problemanswer.correct) ? "correct" : "incorrect"
  end
end
