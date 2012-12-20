class HomeworkProblemStat < ProblemSetElt
  belongs_to :homework_problem, :foreign_key => :count
  belongs_to :user_stat, :foreign_key => 
end

class HomeworkProblem < ProblemSetElt
end
