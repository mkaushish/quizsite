class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher
  has_many :class_assignments
  has_many :students, :through => :class_assignments

  has_many :hw_assignments
  has_many :homeworks, :through => :hw_assignments

  def assign!(tmp)
    if tmp.is_a?(Homework)
      hw_assignments.create(:homework => tmp)
      students.each do |student|
        # ptypes should be in order to begin with
        QuizUser.create(:student => student, :quiz => tmp, :problem_order => tmp.ptypes)
      end

    elsif tmp.is_a?(Student)
      class_assignments.create(:student => tmp)
      homeworks.each do |hw|
        QuizUser.create(:student => tmp, :quiz => hw, :problem_order => hw.ptypes)
      end
    end
  end
end
