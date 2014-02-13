# ATTRIBUTES:
#   name: in our case often "N: Chapter name"
#   user_id: nil for the default problem sets, teacher_id for those created by teachers
class ProblemSet < ActiveRecord::Base
	attr_reader :ptype_params # used in initialization
	attr_accessible :name, :ptype_params, :description, :video_link, :image

	belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'

	has_many :problem_set_problems
	has_many :problem_types, :through => :problem_set_problems
	has_many :problem_set_instances
	has_many :users, :through => :problem_set_instances
	has_many :classroom_problem_sets
	has_many :classrooms, :through => :classroom_problem_sets
	has_many :quizzes

	validate :name, :presence => true,
				  :uniqueness => true

	accepts_nested_attributes_for :problem_set_problems, :allow_destroy => true

	before_validation :parse_ptype_params

	after_create :assign_problem_set_to_teacher_classrooms

	def assign(user)
		instance = problem_set_instances.build(:user_id => user.id)
		# instance.num_blue = instance.problem_stats.blue.count
		# instance.num_green = instance.problem_stats.green.count
		# instance.num_red = instance.problem_stats.count - instance.num_blue - instance.num_green
	 	return nil unless instance.save # if they already have an instance of this problem set it won't work
	end

	def self.master_sets
		ProblemSet.where("user_id IS NULL")
  	end

  	def self.master_sets_with_ptypes
		ProblemSet.where("user_id IS NULL").includes("problem_types")
  	end

  	def idname
		return "problem_set_#{self.id}"
  	end

  	def ptypes_hash
		@ptypes_hash ||= Hash[ problem_set_problems.to_a.map { |e| [e.problem_type_id, e] } ]
  	end

  	def clone_for(user)
		user.problem_set.new(name: name)
  	end

	def add_problem_type(problem_types)
		ptypes_hash[problem_type.id] ||= self.problem_set_problems.new(problem_type: problem_type)
	end

  	def del_problem_type!(problem_type)
		ptyps_hash[problem_type.id].delete if ptypes_hash[problem_type.id]
		ptyps_hash[problem_type.id] = nil
  	end

  	def default_quiz
		@q = quizzes.where(:user_id => nil).first
		if @q.nil?
	  		@q = quizzes.create
	  		@q.default_problems
	  		@q.save
		end
		@q
  	end

  	def chart_classroom_problem_set_problem_types_students_percentage_correct
		chart_data = [['Problem Types','Correct Percentage']]
		self.problem_types.each do |problem_type|
			answers_stats = problem_type.total_correct_wrong_problem_type_answers
			total_answers = answers_stats[0] 
			correct_answers = answers_stats[1] 
			wrong_answers = answers_stats[2] 
			if total_answers > 0 
				chart_data.push([problem_type.name, (correct_answers*100)/(total_answers)]) 
			end
		end
		return chart_data 
  	end   

  	def chart_percentage_of_correct_answers_by_problem_set
		chart_data = [['Problem Types','Correct Percentage']]
		self.problem_types.each do |problem_type| 
	  		answers_stats = problem_type.total_correct_wrong_problem_type_answers 
	  		total_answers = answers_stats[0] 
	  		correct_answers = answers_stats[1] 
	  		wrong_answers = answers_stats[2] 
	  		if (total_answers) > 0   
				chart_data.push([problem_type.name, (correct_answers*100)/(total_answers)]) 
	  		end   
		end 
		if chart_data.count == 1
	  		chart_data.push(["Haven't Attempted",100]) 
		end
		return chart_data
  	end

  	def chart_percentage_of_wrong_answers_by_problem_set
		chart_data = [['Problem Types','Wrong Answers']]
		self.problem_types.each do |problem_type|
	  		wrong_answers = problem_type.answers_correct.select{|v| v == false }.count 
	  		chart_data.push([problem_type.name, wrong_answers]) 
		end  
		return chart_data
  	end

  	def history(student_id)
  		history_array = Array.new
		self.problem_types.each do |problem_type|
			total_answers_count = 0
			correct_answers_count = 0
			answers = problem_type.student_answers_correct(student_id)
			total_answers_count = answers.count
			correct_answers_count = answers.select{|v| v == true}.count
			history_array.push [problem_type.id, problem_type.name, correct_answers_count, total_answers_count]
		end
		return history_array
	end

  	private

	def parse_ptype_params
	  	if @ptype_params && problem_types.empty?
			self.problem_types = ProblemType.where(id: @ptype_params.keys)
	  	end
	  	self
	end

	def assign_problem_set_to_teacher_classrooms
		teacher = self.owner
		unless teacher.blank?
			teacher.classrooms.each do |classroom|
				classroom.classroom_problem_sets.create( problem_set_id: self.id, active: false )
			end
		end
	end
end