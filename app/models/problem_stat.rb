class ProblemStat < ActiveRecord::Base
	attr_accessible :user, :user_id, :problem_type, :problem_type_id

	belongs_to :user
	belongs_to :problem_type
	# has_many :answers, through: :problem_type
	has_many :problem_generators, through: :problem_type # I think this is unused TODO
	has_many :problem_set_stats
	has_many :quiz_stats
	has_many :quiz_problem_stats
	has_many :problem_set_stats
	has_many :answers, :finder_sql => proc { %Q{
		SELECT "answers".* FROM "answers" 
		WHERE "answers"."user_id" = #{user_id}
		AND "answers"."problem_type_id" = #{problem_type_id}
		ORDER BY created_at DESC
	} }

	validates :problem_type, :presence => true
	validates :user, :presence => true
	validates :count, :presence => true,
										:numericality => { :only_integer => true,
																			 :greater_than_or_equal_to => 0 }
	validates :correct, :presence => true,
											:numericality => { :only_integer => true,
																				 :greater_than_or_equal_to => 0 }
	before_save :update_color

	def update_w_ans!(answer)
		if answer.points == 0 or answer.points.nil?
			answer.points = points_for(answer.correct)
			answer.save
		end
		self.count += 1
		self.correct += 1 if answer.correct
		
		self.points += answer.points
		user.add_points!(answer.points)
		modify_rewards(answer.correct)

		save
		self
	end

	def smart_score
		return "?" if count == 0
		return correct.to_f / count
	end

	def points_for(correct)
		return 10 if green? && correct
		return 0 if green? && !correct
		correct ? points_right : points_wrong
	end

	def modify_rewards(correct)
		if correct
			self.points_right = (points_right * 1.12)
			self.points_wrong -= 10
		else
			self.points_right -= 10
			self.points_wrong += 10
		end

		total_points_required = self.points_required

		if points >= total_points_required
			time = Time.now.utc
			time += (60*60*18) * (1+self.correct.to_i)
			self.stop_green = time.to_time.utc
			self.save
		end

		self.points_wrong = 0 if points_wrong < 0
		self.points_wrong = 50 if points_wrong > 50
		self.points_right = 70 if points_right < 70
		self.points_right = 500 if points_right > 500

		self
	end

	def green?
		stop_green > Time.now.utc
	end

	def set_stop_green
		# time = Time.now.utc
		# time += (60*60) * points_over_green
		# self.stop_green = time.to_time.utc
	end

	def set_stop_green_new
		# time = Time.now.utc
		# time += (60*60) * points_over_green
		# self.stop_green = time.to_time.utc
		# self.save
	end

	def set_new_points
		self.points_required += 500
		self.save
	end
	
	def points_till_green
		self.points_required - points
	end

	def points_over_green
		points - self.points_required
	end

	def set_yellow
		self.points_right = 85
		self.points_wrong = 30
	end

	def set_yellow!
		set_yellow
		return save
	end

	def color_status
		if green?
			'green'
		else
			# 89 means if you fail once and succeed next time it becomes yellow (90 poins)
			((points_wrong > 0) || (points > 89)) ? 'yellow' : 'red'
		end
	end

	def self.blue
		where("stop_green > ?", Time.now.utc)
	end

	def self.green
		where("points_wrong > ?", 0)
	end

	def self.red
		where("points > ?", 89)
	end

	private

	def update_color
		self.color = self.color_status
	end

###################################################################
# Yellow replaced with green and green with blue                  #
###################################################################
	
	# def points_for(correct)
	#   return 10 if blue? && correct
	#   return 0 if blue? && !correct
	#   correct ? points_right : points_wrong
	# end

	# def modify_rewards(correct)
	#   if correct
	#     self.points_right = (points_right * 1.12)
	#     self.points_wrong -= 10
	#   else
	#     self.points_right -= 10
	#     self.points_wrong += 10
	#   end

	#   if Time.now >= self.stop_green
	#     set_new_points
	#   end
		
	#   total_points_required = self.points_required

	#   if points > total_points_required
	#     set_stop_blue
	#   end

	#   self.points_wrong = 0 if points_wrong < 0
	#   self.points_wrong = 50 if points_wrong > 50
	#   self.points_right = 70 if points_right < 70
	#   self.points_right = 500 if points_right > 500

	#   self
	# end

	# def blue?
	#   stop_green > Time.now
	# end

	# def set_stop_blue
	#   time = Time.now
	#   time += (60*60) * points_over_green
	#   self.stop_green = time
	# end

	# def set_new_points
	#   self.points_required += 500
	# end
	
	# def points_till_blue
	#   self.points_required - points
	# end

	# def points_over_blue
	#   points - self.points_required
	# end

	# def set_green
	#   self.points_right = 85
	#   self.points_wrong = 30
	# end

	# def set_green!
	#   set_green
	#   return save
	# end

	# def color_status
	#   if blue?
	#     'blue'
	#   else
	#     # 89 means if you fail once and succeed next time it becomes yellow (90 poins)
	#     ((points_wrong > 0) || (points > 89)) ? 'green' : 'red'
	#   end
	# end

	# def self.blue
	#   where("stop_green > ?", Time.now)
	# end

	# def self.green
	#   where("points_wrong > ?", 0)
	# end

	# def self.red
	#   where("points > ?", 89)
	# end
end