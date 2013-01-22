class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher
  has_many :classroom_assignments
  has_many :students, :through => :classroom_assignments

  has_many :classroom_problem_sets
  has_many :problem_sets, :through => :classroom_problem_sets

  has_many :quizzes

  def assign!(tmp)
    if tmp.is_a?(User)
      $stderr.puts "Assigning Student"
      class_assignments.create(:student => tmp)
      homeworks.each { |hw| hw.allow_access(tmp) }
    else
      raise "You can only assign a Student to a class, not a #{tmp.class}"
    end
  end
end
