class ClassroomTeacher < ActiveRecord::Base
  attr_accessible :classroom_id, :teacher_id

  belongs_to :classroom
  belongs_to :teacher
  
end
