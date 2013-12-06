class Lesson < ActiveRecord::Base

  	belongs_to :classroom
  	belongs_to :teacher

  	attr_accessible :classroom_id, :end_time, :start_time, :teacher_id
end
