class Admin < User
  has_many :classrooms, :dependent => :destroy, :foreign_key => 'teacher_id'
  has_many :problem_sets, :foreign_key => 'user_id'
end
