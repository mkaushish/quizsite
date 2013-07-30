namespace :generate do    
    desc "Generate Fake Classrooms With two Problem Sets"
    task :fake_classrooms => :environment do

        @teacher = Teacher.find_by_email("t.homasramfjord@gmail.com")
        puts "Teacher with email #{@teacher.email} found" unless @teacher.nil?

        @problem_set_1 = ProblemSet.find_by_name("Knowing our Numbers")
        @problem_set_2 = ProblemSet.find_by_name("Whole Numbers")
        
        i = 1
        n = 3
        while i < n do
            @classroom = Classroom.create(:name => "Sample_Classroom_#{i}")
            @classroom_teacher = @classroom.classroom_teachers.create(:teacher_id => @teacher.id) unless @classroom.nil?
            puts "Classroom #{i} created" unless @classroom.nil? and @classroom_teacher.nil?

            @classroom.assign!(@problem_set_1)
            @classroom.assign!(@problem_set_2)
            
            i += 1
        end
    end
end