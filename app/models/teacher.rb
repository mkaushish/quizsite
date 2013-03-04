class Teacher < User
  has_many :homeworks, :foreign_key => 'user_id'
  has_many :classrooms, :dependent => :destroy
  has_many :problem_sets, :foreign_key => 'user_id'

  # we can't do below, afaik, but we don't want to anyway - every time we want a group of
  # students for a teacher, we will want the students associated with a certain classroom,
  # and if not we can just get the students manually
  # has_many :students, :through => :classrooms
end
