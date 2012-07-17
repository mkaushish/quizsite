class Student < User
  has_many :practice_sets, :foreign_key => 'user_id'
  has_many :class_assignments
  has_many :classrooms, :through => :class_assignments

  after_create :add_default_quizzes

  def assign_classroom(c)
    # TODO improve me a little...
    classrooms << c # unless classrooms.find(c.id)
  end

  private

  # Add a default quiz for each chapter
  def add_default_quizzes
    CHAPTERS.each do |chapter|
      practice_sets.create!(:problemtypes => Marshal.dump(chapter::PROBLEMS), :name => chapter.to_s)
    end
  end
end
