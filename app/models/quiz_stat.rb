class QuizStat < ActiveRecord::Base
	include CurrentProblem
	include FollowsProblemStat

	belongs_to :problem_type
	belongs_to :quiz_instance
	delegate   :user, :to => :quiz_instance

	validates :quiz_instance, :presence => true

	# def points_for(correct) 
	# 	if(correct)
	# 	  	100
	# 	else 
	# 	  	0
	# 	end
	# end

	def update_w_ans!(answer)
		# answer.points = points_for(answer.correct)
		
		answer.points = points_for(answer, self.quiz_instance.quiz.quiz_type)
		answer.save

		self.problem_stat = stat.update_w_ans!(answer)
		
		self.remaining = remaining - 1
		change_problem
		save
	end

	def points_for(answer, quiz_type)
		if quiz_type == 2
			if answer.correct
				_time_taken = answer.time_taken
				case 
					when (_time_taken < 200)
						_points = 200 - _time_taken + 10
					when (_time_taken > 200)
						_points = 10
				end
			else
				_points = -100
			end
		else
			if(correct)
				_points = 100
			else 
			  	_points = 0
			end
		end
		return _points
	end
end