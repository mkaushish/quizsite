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
  
  def problemanswers(user = nil)
    user ||= current_user
    return [] if user.nil?
    tmp = user.problemanswers.limit(15).order('created_at DESC')
    $stderr.puts "FISHY AFOOT" * 100 + "\n#{tmp}"
    return tmp
  end
end
