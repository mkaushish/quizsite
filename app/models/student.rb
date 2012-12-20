class Student < User
  has_many :class_assignments
  has_many :classrooms, :through => :class_assignments

  # after_create :add_default_quizzes

  private

  # Add a default quiz for each chapter
  def add_default_quizzes
    #CHAPTERS.each do |chapter|
    #  practice_sets.create!(:problemtypes => Marshal.dump(chapter::PROBLEMS), :name => chapter.to_s)
    #end

    # for now we'll assign them to my class instead, and then assign that class quizzes
    classroom = User.find_by_email("t.homasramfjord@gmail.com").classrooms.first
    classroom.assign!(self)
  end
end
