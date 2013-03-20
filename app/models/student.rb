class Student < User
  has_many :classroom_assignments
  has_many :classrooms, :through => :classroom_assignments
  has_many :teachers, :through => :classrooms

  def problem_history(*ptypes)
    ptypes_list = ptypes
    if ptypes[0].is_a? Array
      ptypes_list = ptypes[0]
    end

    answers.where(:problem_type_id => ptypes_list)
           .order("created_at DESC")
           .includes(:problem)
  end
end
