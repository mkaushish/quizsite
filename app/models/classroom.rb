class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher, class_name: "User"
  has_many :classroom_assignments, :dependent => :destroy
  has_many :students, :through => :classroom_assignments

  has_many :classroom_problem_sets, :dependent => :destroy
  has_many :problem_sets, :through => :classroom_problem_sets

  has_many :quizzes

  def assign!(jimmy)
    if jimmy.is_a?(Student)
      $stderr.puts "Assigning Student"
      classroom_assignments.create(:student => jimmy)
      problem_sets.each { |hw| hw.assign(jimmy) } # sorry jimmy

    elsif jimmy.is_a?(ProblemSet)
      classroom_problem_sets.create :problem_set => jimmy
      students.each { |stu| jimmy.assign(stu) }

    else
      # TODO allow to assign problem sets
      raise "You can only assign a Student to a class, not a #{jimmy.class}"
    end
  end
end
