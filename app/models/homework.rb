class Homework < Quiz
  belongs_to :teacher, :foreign_key => 'user_id'
  has_many :hw_assignments
  has_many :classrooms, :through => :hw_assignments
end
