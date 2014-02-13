# representsthe assignment ofa student to a classroom
class ClassroomAssignment < ActiveRecord::Base
  	attr_accessible :student, :classroom
  	
  	belongs_to :student
  	belongs_to :classroom, counter_cache: :students_count
end