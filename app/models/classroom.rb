class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher
  has_many :class_assignments
  has_many :students, :through => :class_assignments

  has_many :hw_assignments
  has_many :homeworks, :through => :hw_assignments

  def assign!(tmp)
    if tmp.is_a?(Quiz)
      $stderr.puts "Assigning Homework: #{students.all}"
      hw_assignments.create!(:homework => tmp)
      #students.each { |student| tmp.allow_access(student) }
      students.each do |student| 
        blah = student.id
        $stderr.puts "ALLOWING ACCESS FOR #{blah}" # #{student.name}, #{student.id}"
        tmp.allow_access(blah) 
      end

    elsif tmp.is_a?(User)
      $stderr.puts "Assigning Student"
      class_assignments.create(:student => tmp)
      homeworks.each { |hw| hw.allow_access(tmp) }
    else
      $stderr.puts "WTF THIS ISN'T SUPPOSE TO HAPPEN"
    end
  end
end
