class ClassroomProblemSet < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :problem_set
end