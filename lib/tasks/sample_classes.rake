namespace :generate do
  desc "Adding students, classrooms, and test data for the teacher view"
  task :classrooms => :environment do

    # ADD SAMPLE CLASS STUDENTS
    def to_email(name) ; "#{name.gsub(/ /, '.')}@smartergrades.com".downcase ; end
    def student(i) ; "Student Number #{i}" ; end
    
    (student(1)..student(55)).each do |student|
      User.find_by_email(to_email(student)).delete if User.find_by_email(to_email(student))
      user = Student.new( {
        :name  => student,
        :email => to_email(student),
        :password => "newpass",
        :password_confirmation => "newpass",
      } )
      user.confirmed = true

      if user.save
        puts "#{user.name} successfully added"
      else
        puts "#{user.email} could not be added: "
      end
    end

    # ADD CLASSES FOR EACH TEACHER
    teachers = [ "t.homasramfjord@gmail.com", "m.adhavkaushish@gmail.com" ]
    chapters = [ Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7 ]

    end_class = Time.now.to_i
    day_s = 60 * 60 * 24

    teachers.map { |email| User.find_by_email(email) }.each do |teacher|

      $stderr.puts "creating classrooms"
      teacher.classrooms.each { |c| c.delete }
      class1 = teacher.classrooms.create!(:name => '6a')
      class2 = teacher.classrooms.create!(:name => '6b')

      $stderr.puts "adding students to class 1 for #{teacher.name}"
      (student(1)..student(30)).each do |name| 
        class1.assign! Student.find_by_email( to_email(name) )
      end
      $stderr.puts "adding students to class 2 for #{teacher.name}"
      (student(31)..student(55)).each do |name| 
        class2.assign! Student.find_by_email( to_email(name) )
      end

      # Generate homeworks
      $stderr.puts "generating homeworks"
      teacher.homeworks.each { |c| c.delete }
      teacher.save
      chapters.reverse.each_with_index do |ch, chno|
        hw = teacher.homeworks.build(:problemtypes => Marshal.dump(ch::PROBLEMS), :name => ch.to_s)
        if hw.save
          $stderr.puts "generating #{ch} homework for #{teacher.name}"
          class1.assign!(hw)
          class2.assign!(hw)
        else
          $stderr.puts "#{ch} hw couldn't be saved for #{teacher.name}"
        end
      end # each chap
    end # each teacher

    # Generate student data for each problem
    $stderr.puts "Generating Problems!!!"
    students = (student(1)..student(55)).map { |n| Student.find_by_email(to_email(n)) }
    chapters.reverse.each_with_index do |ch, chno|
      count = 0
      now = end_class - chno * day_s * 4

      4.times do |i|
        ch::PROBLEMS.each do |pr| 
          $stderr.print "generating #{ch} data: problem = #{pr}, #{"*"*i}: "
          prob=Problem.new
          prob.my_initialize(pr)
          prob.save
          students.each do |student|
            tmp = student.problemanswers.create(
              :problem  => prob, 
              :correct  => ( rand <= 0.73 + i * 0.05 ),
              :response => Marshal.dump({}) 
            )
            tmp.created_at = Time.at now
            tmp.save
            $stderr.print (tmp.correct?) ? '+':'-'
          end
          $stderr.puts
          now += rand(20) + 20
        end # probs.each
        puts "\r#{ch} data generated"
      end # 4.times
    end # chaps.each

  end # chaps.each
end
