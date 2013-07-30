require 'debugger'

namespace :generate do
    desc "Generate three sample classrooms with 30 users each and having problems correct as 80%, 70& and 60%"
    task :fake_data => :environment do

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
        @problem_set_2 = ProblemSet.find_by_name("Whole Numbers")
        
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


        (student(1)..student(24)).each do |name| 
            @student = Student.find_by_email( to_email(name) )
            @instance ||= @student.problem_set_instances.new(:problem_set => @problem_set_1)
            @stats = @instance.stats
            @problem_set_1.problem_types.each do |ptype|
                debugger
                @stat = @instance.stat(ptype)
                @problem = @stat.spawn_problem
                @answer = @student.answers.create(:correct => false, :problem_id => @problem.id, :problem_generator_id => @problem.problem_generator_id, :problem_type_id => ptype.id, session: @instance)
                @stat.update_w_ans!(@answer)
            end
            
            # @student = Student.find_by_email( to_email(name) )
            # @instance ||= @student.problem_set_instances.create(:problem_set => @problem_set_1)
            # @stats = @instance.stats
            # @problem_set_1.problem_types.each do |ptype|
            #     debugger
            #     @stat = @instance.stat(ptype)
            #     @problem = @stat.spawn_problem
                # @new_stat = @student.problem_stats.where("problem_type_id = ?", ptype.id).last
                # @new_stat ||= @student.problem_stats.new(:problem_type => ptype)
                #@stat = ProblemSetStat.includes(:problem_set_instance).includes(:problem_type).find_by_id(@new_stat.id)
                #@problem = @stat.spawn_problem
                # @answer = @student.answers.create(:correct => true, :problem_id => @problem.id, :problem_generator_id => @problem.problem_generator_id, :problem_type_id => ptype.id, session: @instance)
                # @stat.update_w_ans!(@answer)
            # end
            
        end
        
        (student(25)..student(30)).each do |name| 
            @student = Student.find_by_email( to_email(name) )
            @instance ||= @student.problem_set_instances.new(:problem_set => @problem_set_1)
            @stats = @instance.stats
            @problem_set_1.problem_types.each do |ptype|
                @stat = @instance.stat(ptype)
                @problem = @stat.spawn_problem
                @answer = @student.answers.create(:correct => false, :problem_id => @problem.id, :problem_generator_id => @problem.problem_generator_id, :problem_type_id => ptype.id, session: @instance)
                @stat.update_w_ans!(@answer)
            end
            @instance ||= @student.problem_set_instances.new(:problem_set => @problem_set_2)
            @stats = @instance.stats
            @problem_set_2.problem_types.each do |ptype|
                @stat = @instance.stat(ptype)
                @problem = @stat.spawn_problem
                @answer = @student.answers.create(:correct => false, :problem_id => @problem.id, :problem_generator_id => @problem.problem_generator_id, :problem_type_id => ptype.id, session: @instance)
                @stat.update_w_ans!(@answer)
            end
            @instance ||= @student.problem_set_instances.new(:problem_set => @problem_set_3)
            @stats = @instance.stats
            @problem_set_3.problem_types.each do |ptype|
                @stat = @instance.stat(ptype)
                @problem = @stat.spawn_problem
                @answer = @student.answers.create(:correct => false, :problem_id => @problem.id, :problem_generator_id => @problem.problem_generator_id, :problem_type_id => ptype.id, session: @instance)
                @stat.update_w_ans!(@answer)
            end
        end
  
  end
end
