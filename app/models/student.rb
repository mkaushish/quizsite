class Student < User
  has_many :classroom_assignments
  has_many :classrooms, :through => :classroom_assignments
  has_many :teachers, :through => :classrooms
end
