namespace :generate do
  desc "Adding students, classrooms, and test data for the teacher view"
  task :classrooms => :environment do

    # ADD SAMPLE CLASS STUDENTS
    def to_email(name) ; "#{name.gsub(/ /, '.')}@smartergrades.com" ; end
    def student(i) ; "Student Number #{i}" ; end
    
    (student(1)..student(55)).each do |student|
      User.find_by_email(to_email(student)).delete if User.find_by_email(to_email(student))
      user = User.new( {
        :name  => student,
        :email => to_email(student),
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

    # ADD CLASSES FOR EACH TEACHER
    teachers = [ "t.homasramfjord@gmail.com", "m.adhavkaushish@gmail.com" ]

    end_class = Time.now.to_i
    day_s = 60 * 60 * 24

    teachers.map { |email| User.find_by_email(email).identifiable }.each do |teacher|
      # TODO
      teacher.classrooms.each { |c| c.delete }
      class1 = teacher.classrooms.create!(:name => '6a')
      class2 = teacher.classrooms.create!(:name => '6b')

      (student(1)..student(30)).each do |name| 
        User.find_by_email( to_email(name) ).identifiable.assign_classroom( class1 )
      end
      (student(31)..student(55)).each do |name| 
        User.find_by_email( to_email(name) ).identifiable.assign_classroom( class1 )
      end

      chap=[Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7]
      chap.reverse.each_with_index do |ch, chno|
        puts "generating #{ch} homework for #{teacher.user.name}"

        # Make homework and assign it
        hw = teacher.homeworks.create!(:problemtypes => ch::PROBLEMS, :name => ch.to_s)
        teacher.classrooms.each { |c| c.assign!(hw) }

        # give students some progress and shit here
      end # each chap
    end # each teacher

    chap=[Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7]
    chap.reverse.each_with_index do |ch, chno|
      (student(1)..student(55)).each do |name|
        puts "generating #{ch} data for #{user.name}"

        now = end_class - chno * day_s * 4

        10.times do |i|
          ch::PROBLEMS.each do |pr| 
            prob=Problem.new
            prob.my_initialize(pr)
            prob.save
            tmp = user.identifiable.problemanswers.create(
              :problem  => prob, 
              :correct  => ( rand > 0.7 + i * 0.2 ),
              :response => Marshal.dump({}) 
            )
            tmp.created_at = Time.at now
            tmp.save
            now += rand(20) + 20
          end
        end # 10 times
      end # students.each
    end # chaps.each
  end
end
