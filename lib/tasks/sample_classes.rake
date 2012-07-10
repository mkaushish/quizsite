namespace :generate do
  task :classrooms do

    # ADD SAMPLE CLASS STUDENTS
    student_name = "Student Number 1"
    55.times do |student|
      unless User.find_by_email(userhash[:email])
        user = User.new( {
          :name => student_name,
          :email => "#{student_name.gsub(/ /, '.')}@smartergrades.com",
          :password => "newpass",
          :password_confirmation => "newpass",
          :identifiable => Student.create
        } )
        user.confirmed = true

        if user.save!
          puts "#{user.name} successfully added"
        else
          puts "#{user.name} could not be added: "
        end
      end
    end

    # ADD CLASSES FOR EACH TEACHER
    teachers = [ "t.homasramfjord@gmail.com", "m.adhavkaushish@gmail.com" ]
    teachers.each do |teacher|
      teacher.classrooms.create(:name => '6a')
      teacher.classrooms.create(:name => '6b')

      chap=[Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7]
      chap.each do |ch|

        # Make homework and assign it
        hw = teacher.homeworks.new(:problemtypes => ch::PROBLEMS, :name => ch.to_s)
        teacher.classrooms.each { |c| c.assign!(hw) }

        # give students some progress and shit here
        ch::PROBLEMS.each do |pr| 
          10.times do
            prob=Problem.new
            prob.my_initialize(pr)
            prob.save
            user.problemanswers.create(
              :problem  => prob, 
              :correct  => [true, false].sample,
              :response => Marshal.dump({}))
          end
        end
      end

    end
  end
end
