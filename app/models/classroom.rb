require 'digest'

class Classroom < ActiveRecord::Base
    attr_accessible :name, :student_password, :teacher_password
    
    has_many :classroom_teachers, :dependent => :destroy
    has_many :teachers, :through => :classroom_teachers    
    
    has_many :classroom_assignments, :dependent => :destroy
    has_many :students, :through => :classroom_assignments
    has_many :classroom_problem_sets, :dependent => :destroy
    has_many :problem_sets, :through => :classroom_problem_sets,
                            :order => 'classroom_problem_sets.created_at ASC'
    has_many :classroom_quizzes, :dependent => :destroy
    has_many :quizzes

    validates :student_password, :uniqueness => true
    validates :teacher_password, :uniqueness => true
    validates :name, :presence => true
    after_create :new_password

    def self.smarter_grades
        where(:teacher_id => nil).first
    end

    # Assign a student or problem_set to this class
    def assign!(jimmy)
        if jimmy.is_a?(Student)
            $stderr.puts "Assigning Student"
            classroom_assignments.create(:student => jimmy)
            problem_sets.each { |hw| hw.assign(jimmy) } # sorry jimmy

        elsif jimmy.is_a?(ProblemSet)
            classroom_problem_sets.create :problem_set => jimmy
            students.each { |stu| jimmy.assign(stu) }

        elsif jimmy.is_a?(Quiz)
            assign_quiz(jimmy)

        else
            # TODO allow to assign problem sets
            raise "Classroom.assign! accepts a Student, ProblemSet, or Quiz. Given #{jimmy.inspect}"
        end
    end

    def assign_quiz(quiz)
        classroom_quizzes.create :quiz => quiz
        pset = problem_sets.where(:id => quiz.problem_set_id).first

        if pset.nil?
            raise "Classroom: can only assign a quiz is quiz.problem_set is already assigned!"
        end

        pset_instances = problem_set_instances.where(:problem_set_id => pset.id)
        pset_instances.each { |psi| quiz.assign_with_pset_inst psi }
    end

    # def class_pass
    #     self.password ||= new_password
    # end

    # generates a random lowercase alphanumeric password
    def rand_password
        num_chars = 7
        chars = ('a'..'z').to_a + ('0'..'9').to_a
        n = chars.length
        seed = rand n**num_chars
        pass = []
        while seed > 1
            pass << chars[seed % n]
            seed /= n
        end
        pass.join
    end

    def new_password
        begin
            self.student_password = rand_password if self.student_password.nil?
            self.teacher_password = rand_password if self.teacher_password.nil?
        end while !save
        student_password
        teacher_password
    end

    def chart_percentage_of_students_answers_correct_by_problem_sets_with_intervals(problem_set)
        chart_data = [['%correct','Number of Students']]
        temp = []
        self.students.each do |student| 
            pset_instance = student.problem_set_instances_problem_set(problem_set)
            answers_stats = pset_instance.total_correct_wrong_problem_set_instance_answers
            total_answers = answers_stats[0] 
            correct_answers = answers_stats[1] 
            wrong_answers = answers_stats[2] 
            if total_answers == 0 
                temp.push(-1) 
            else 
                temp.push((correct_answers*100)/(total_answers)) 
            end        
            
        end
        chart_data = pick_values(chart_data, temp) 
        return chart_data
    end

    def chart_over_all_students_answer_stats
        chart_data = [['%correct','Number of Students']]
        temp = []
        self.students.each do |student| 
            answers_stats = student.total_correct_wrong_answers 
            total_answers = answers_stats[0] 
            correct_answers = answers_stats[1] 
            wrong_answers = answers_stats[2] 
            if total_answers == 0
                temp.push(-1) 
            else 
                temp.push((correct_answers * 100) / (total_answers)) 
            end        
        end
        chart_data = pick_values(chart_data, temp) 
        return chart_data
    end


    def pick_values(chart_data, temp)
        select_90_to_100 = (temp.select{|v| v>=90}).count 
            chart_data.push(["90-100%", select_90_to_100])
        select_80_to_90 = ((temp.select{|v| v>=80}).select{|v| v<90}).count   
            chart_data.push(["80-90%", select_80_to_90])
        select_70_to_80 = ((temp.select{|v| v>=70}).select{|v| v<80}).count   
            chart_data.push(["70-80%", select_70_to_80])
        select_60_to_70 = ((temp.select{|v| v>=60}).select{|v| v<70}).count   
            chart_data.push(["60-70%", select_60_to_70])
        select_30_to_60 = ((temp.select{|v| v>=30}).select{|v| v<60}).count   
            chart_data.push(["30-60%", select_30_to_60])
        select_0_to_30 = ((temp.select{|v| v>=0}).select{|v| v<30}).count    
            chart_data.push(["0-30%", select_0_to_30])
        select_0 = (temp.select{|v| v<0}).count    
            chart_data.push(["Haven't Attempted", select_0])
        return chart_data
    end
end