class Relationship < ActiveRecord::Base
  	attr_accessible :coach_id, :student_id, :relation

  	belongs_to :coach
  	belongs_to :student
end
