class ClassroomQuiz < ActiveRecord::Base
  attr_accessible :classroom, :quiz
  belongs_to :classroom
  belongs_to :quiz
end
