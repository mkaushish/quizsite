module ProblemSetsHelper
	def print_ps(problem_set)
		"<b class=problem_set>#{problem_set.name}</b>".html_safe
	end

end