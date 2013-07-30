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
        Rake::Task["generate:fake_students"].invoke
        
        #  ADD SAMPLE CLASSROOM WITH THE SAME TEACHER # 
        
        Rake::Task["generate:fake_classrooms"].invoke

        # ASSIGN PROBLEM SETS TO EACH CLASSROOM #
        
        i = 1
        n = 3
        while i < n
            @classroom = Classroom.find_by_name("Sample_Classroom_#{i}")
            (student(1)..student(30)).each do |name| 
                @classroom_1.assign! Student.find_by_email( to_email(name) )
            end
        end
        
        
        
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

        
        (student(1)..student(30)).each do |name| 
            @student = Student.find_by_email( to_email(name) )
            @instance = @student.problem_set_instances.where("problem_set_id = ?", @problem_set_1).last
            @instance ||= @student.problem_set_instances.create(:problem_set => @problem_set_1)
            @stats = @instance.stats
            @problem_set_1.problem_types.each do |problem_type|
                i = 0
                tot=rand(4)+8
                while i < tot
                    stat = @instance.problem_set_stats.where(:problem_type_id => problem_type.id).last
                    stat ||= @instance.problem_set_stats.create(:problem_type => problem_type)
                    stat.problem_stat = stat.problem_stat || @student.problem_stats.where(:problem_type_id => problem_type.id).first || @student.problem_stats.new(:problem_type => problem_type)
                    @stat = stat
                    @problem = @stat.spawn_problem
                    if (rand(100)/100.0 >= 0.2)
                        @solution = @problem.problem.prefix_solve
                    else
                        @solution = {"qbans_ans"=>"blahblah"}
                    end
                    @correct = @problem.correct? @solution
                    @answer = @student.answers.create(problem_id: @problem.id, response: @solution, problem_generator_id: @problem.problem_generator_id, session: @instance, problem_type_id: problem_type.id, correct: @correct)
                    @stat.update_w_ans!(@answer)
                    i+=1
                end
            end
        end
    end
end
