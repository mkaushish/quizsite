require 'digest'

class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher, class_name: "User"
  has_many :classroom_assignments, :dependent => :destroy
  has_many :students, :through => :classroom_assignments

  has_many :classroom_problem_sets, :dependent => :destroy
  has_many :problem_sets, :through => :classroom_problem_sets,
                          :order => 'classroom_problem_sets.created_at ASC'

  has_many :classroom_quizzes, :dependent => :destroy
  has_many :quizzes

  validates :password, :uniqueness => true
  validates :name, :presence => true
  after_create :new_password

  def self.smarter_grades
    where(:teacher_id => nil).first
  end

  # Assign a student or problem_set to this class
  def assign!(jimmy)
    if jimmy.is_a?(Student)
      $stderr.puts "Assigning Student"
      classroom_assignments.create(:student => jimmy)
      problem_sets.each { |hw| hw.assign(jimmy) } # sorry jimmy

    elsif jimmy.is_a?(ProblemSet)
      classroom_problem_sets.create :problem_set => jimmy
      students.each { |stu| jimmy.assign(stu) }

    elsif jimmy.is_a?(Quiz)
      classroom_quizzes.create :quiz => jimmy
      students.each { |stu| jimmy.assign(stu) }

    else
      # TODO allow to assign problem sets
      raise "You can only assign! a Student or ProblemSet to a Classroom, not a #{jimmy.class}"
    end
  end

  def class_pass
    self.password ||= new_password
  end

  # generates a random lowercase alphanumeric password
  def rand_password
    num_chars = 7
    chars = ('a'..'z').to_a + ('0'..'9').to_a
    n = chars.length

    seed = rand n**num_chars
    pass = []

    while seed > 1
      pass << chars[seed % n]
      seed /= n
    end

    pass.join
  end

  def new_password
    begin
      self.password = rand_password
    end while !save
    password
  end
end
