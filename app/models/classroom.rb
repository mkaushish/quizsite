class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher
  has_many :class_assignments
  has_many :students, :through => :class_assignments

  has_many :hw_assignments
  has_many :homeworks, :through => :hw_assignments

  def assign!(tmp)
    hw_assignments.create(:homework => tmp)   if tmp.is_a? Homework
    class_assignments.create(:student => tmp) if tmp.is_a? Student
  end
end
