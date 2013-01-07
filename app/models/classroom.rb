class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher
  has_many :classroom_assignments
  has_many :students, :through => :classroom_assignments

  has_many :classroom_problem_sets
  has_many :problem_sets, :through => :classroom_problem_sets

  has_many :classroom_quizzes
  has_many :quizzes, :through => :classroom_quizzes

  def assign!(tmp)
    if tmp.is_a?(Quiz)
      $stderr.puts "Assigning Homework: #{students.all}"
      hw_assignments.create!(:homework => tmp)
      #students.each { |student| tmp.allow_access(student) }
      students.each do |student| 
        blah = student.id
        #$stderr.puts "ALLOWING ACCESS FOR #{blah}" # #{student.name}, #{student.id}"
        tmp.allow_access(blah) 
      end

    elsif tmp.is_a?(User)
      $stderr.puts "Assigning Student"
      class_assignments.create(:student => tmp)
      homeworks.each { |hw| hw.allow_access(tmp) }
    else
      raise "You can assign either a Homework or a Student to a class, not a #{tmp.class}"
    end
  end
end
