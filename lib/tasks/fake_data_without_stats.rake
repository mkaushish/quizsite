namespace :generate do
    desc "Generate three sample classrooms with 30 users each and having problems correct as 80%, 70& and 60%"
    task :fake_data_without_stats => :environment do

        Rake::Task["generate:defaults"].invoke
        # FIND TEACHER #
        #@teacher = Teacher.find_by_email("m.adhavkaushish@gmail.com")
        @teacher = Teacher.find_by_email("t.homasramfjord@gmail.com")
        puts "Teacher with email #{@teacher.email} found" unless @teacher.nil?

        # ADD SAMPLE CLASS STUDENTS #
        def to_email(name) ; "#{name.gsub(/ /, '.')}@smartergrades.com".downcase ; end
        def student(i) ; "Sample Student #{i}" ; end
    
        (student(1)..student(90)).each do |student|
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

        #  ADD SAMPLE CLASSROOM WITH THE SAME TEACHER # 
        @classroom_1 = Classroom.create(:name => "Sample_classroom_1")
        @classroom_teacher_1 = @classroom_1.classroom_teachers.create(:teacher_id => @teacher.id) unless @classroom_1.nil?
        puts "Classroom 1 created" unless @classroom_1.nil? and @classroom_teacher_1.nil?

        @classroom_2 = Classroom.create(:name => "Sample_classroom_2")
        @classroom_teacher_2 = @classroom_2.classroom_teachers.create(:teacher_id => @teacher.id) unless @classroom_2.nil?
        puts "Classroom 2 created" unless @classroom_2.nil? and @classroom_teacher_2.nil?

        @classroom_3 = Classroom.create(:name => "Sample_classroom_3")
        @classroom_teacher_3 = @classroom_3.classroom_teachers.create(:teacher_id => @teacher.id) unless @classroom_3.nil?
        puts "Classroom 3 created" unless @classroom_3.nil? and @classroom_teacher_3.nil?

        # ASSIGN PROBLEM SETS TO EACH CLASSROOM #
        @problem_set_1 = ProblemSet.find_by_name("Knowing our Numbers")
        puts "problem_set #{@problem_set_1} found" unless @problem_set_1.blank?
        @problem_set_2 = ProblemSet.find_by_name("Whole Numbers")
        puts "problem_set #{@problem_set_2} found" unless @problem_set_2.blank?
        
        @classroom_1.assign!(@problem_set_1)
        @classroom_2.assign!(@problem_set_1)
        @classroom_3.assign!(@problem_set_1)

        @classroom_1.assign!(@problem_set_2)
        @classroom_2.assign!(@problem_set_2)
        @classroom_3.assign!(@problem_set_2)

        puts "problem sets assigned to all classrooms"
        
        # ASSIGN CLASSROOM TO STUDENTS, 30 EACH IN A CLASSROOM #

        puts "adding students to classroom_1"
        (student(1)..student(30)).each do |name| 
            @classroom_1.assign! Student.find_by_email( to_email(name) )
        end

        puts "adding students to classroom_2"
        (student(31)..student(60)).each do |name| 
            @classroom_2.assign! Student.find_by_email( to_email(name) )
        end

        puts "adding students to classroom_3"
        (student(61)..student(90)).each do |name| 
            @classroom_3.assign! Student.find_by_email( to_email(name) )
        end

        # (student(1)..student(30)).each do |name| 
        #     @student = Student.find_by_email( to_email(name) )
        #     @instance ||= @student.problem_set_instances.new(:problem_set => @problem_set_2)
        #     puts "#{@problem_set_2.name}"
        #     @problem_set_2.problem_types.each do |ptype|
        #         i = 0
        #         tot=rand(4)+8
        #         while i < tot
        #         problem=ptype.spawn_problem
        #         @answer = @student.answers.create(:correct => (true if (rand(100)/100.0 >= 0.2)), :problem_id => problem.id, :problem_generator_id => problem.problem_generator_id, :problem_type_id => ptype.id, :response => "na") 
        #         puts "answer created" unless @answer.blank?
        #         i += 1
        #         end
        #     end
        # end
        # (student(31)..student(60)).each do |name| 
        #     @student = Student.find_by_email( to_email(name) )
        #     @instance ||= @student.problem_set_instances.new(:problem_set => @problem_set_2)
        #     puts "#{@problem_set_2.name}"
        #     @problem_set_2.problem_types.each do |ptype|
        #         i = 0
        #         tot=rand(4)+8
        #         while i < tot
        #         problem=ptype.spawn_problem
        #         @answer = @student.answers.create(:correct => (true if (rand(100)/100.0 >= 0.2)), :problem_id => problem.id, :problem_generator_id => problem.problem_generator_id, :problem_type_id => ptype.id, :response => "na") 
        #         puts "answer created" unless @answer.blank?
        #         i += 1
        #         end
        #     end
        # end
        # (student(61)..student(90)).each do |name| 
        #     @student = Student.find_by_email( to_email(name) )
        #     @instance ||= @student.problem_set_instances.new(:problem_set => @problem_set_2)
        #     puts "#{@problem_set_2.name}"
        #     @problem_set_2.problem_types.each do |ptype|
        #         i = 0
        #         tot=rand(4)+8
        #         while i < tot
        #         problem=ptype.spawn_problem
        #         @answer = @student.answers.create(:correct =>( true if (rand(100)/100.0 >= 0.2)), :problem_id => problem.id, :problem_generator_id => problem.problem_generator_id, :problem_type_id => ptype.id, :response => "na") 
        #         puts "answer created" unless @answer.blank?
        #         i += 1
        #         end
        #     end
        # end
       
    end
end
