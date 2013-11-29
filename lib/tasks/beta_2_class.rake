namespace :generate do
  desc "Make starting users thomas and madhav"
  task :beta2 => :environment do
  	teacher = User.find_by_email "t.homasramfjord@gmail.com"
  	puts "found teacher: #{teacher}"

  	class1 = teacher.classrooms.where(name: '6').first || teacher.classrooms.new(name: '6')
    class2 = teacher.classrooms.where(name: '7').first || teacher.classrooms.new(name: '7')
  	if class1.save && class2.save
  		puts "classrooms saved successfully"
  	else
  		puts "classroom could not be saved! #{class1.errors.full_messages}"
      puts "classroom could not be saved! #{class2.errors.full_messages}"
  		return
  	end

  	ps1 = (ProblemSet.where name: "Knowing our Numbers")[0]
    ps2 = (ProblemSet.where name: "Fractions")[0]
  	puts "found problem_sets: #{ps1.name}, #{ps2.name}"

    class1.assign! problem_set: ps1
    class2.assign! problem_set: ps2

  	puts "in the end: class1 problem_set: #{class1.problem_sets.first.inspect}"
    puts "in the end: class2 problem_set: #{class2.problem_sets.first.inspect}"
  end
end
