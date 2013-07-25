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
end
