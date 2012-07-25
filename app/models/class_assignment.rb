class ClassAssignment < ActiveRecord::Base
  attr_accessible :student, :classroom
  belongs_to :student
  belongs_to :classroom
end
