class Lesson < ActiveRecord::Base

  	belongs_to :classroom

  	attr_accessible :classroom_id, :end_time, :start_time, :teacher_id
end
