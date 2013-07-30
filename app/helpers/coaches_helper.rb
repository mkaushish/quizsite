module CoachesHelper
	
	def already_added coach,student
		coach.relationships.find_by_student_id(student)
	end

end