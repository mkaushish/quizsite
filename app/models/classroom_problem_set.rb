class ClassroomProblemSet < ActiveRecord::Base
  attr_accessible :classroom, :problem_set
  belongs_to :classroom
  belongs_to :problem_set
end
