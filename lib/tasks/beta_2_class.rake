namespace :generate do
  desc "Make starting users thomas and madhav"
  task :beta2 => :environment do
  	teacher = User.find_by_email "t.homasramfjord@gmail.com"
  	puts "found teacher: #{teacher}"

  	classroom = teacher.classrooms.where(name: '6').first || teacher.classrooms.new(name: '6')
  	if classroom.save
  		puts "classroom saved successfully"
  	else
  		puts "classroom could not be saved! #{classroom.errors.full_messages}"
  		return
  	end

  	problem_set = (ProblemSet.where name: "Knowing our Numbers")[0]
  	puts "found problem_set: #{problem_set}"
  	cps = ClassroomProblemSet.new :classroom => classroom, :problem_set => problem_set
  	if cps.save
  		puts "saved class_problem_set"
  	else
  		puts "classroom_problem_set error: #{cps.errors.full_messages}"
  		return
  	end

  	puts "in the end: class problem_set: #{classroom.problem_sets.first.inspect}"
  end
end
