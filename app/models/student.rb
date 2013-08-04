class Student < User

    attr_accessor :old_password, :new_password, :confirm_password
    attr_accessible :old_password, :new_password, :confirm_password
      
    has_many :classroom_assignments
    has_many :classrooms, :through => :classroom_assignments
    has_many :teachers, :through => :classrooms
    has_many :badges
    has_many :notifications
    has_many :relationships, :dependent => :destroy
    has_many :coaches, :through => :relationships

    # after_create :assign_class #TODO broken

    def problem_history(*ptypes)
        ptypes_list = ptypes
        if ptypes[0].is_a? Array
            ptypes_list = ptypes[0]
        end
        answers.where(:problem_type_id => ptypes_list)
        .order("created_at DESC")
        .includes(:problem)
    end

    def change_password(old_pass, new_pass, confirm_pass)
        if self.encrypted_password == encrypt(old_pass)
            p "password_verified"
            if new_pass = confirm_pass
                self.password = new_pass
                self.password_confirmation = confirm_pass
                if self.save
                    p "Sucess"
                end
            else
                p "Hey, your password doesn't match it's confirmation!"
            end
        else
            p "Hey, your Old password doesn't match!"
        end
    end

    def self.create_with_omniauth(auth)
        student = Student.new
        student.email = auth[:info][:email]
        student.uid = auth[:uid]
        student.name = auth[:info][:name]
        student.first_name = auth[:info][:first_name]
        student.last_name = auth[:info][:last_name]
        student.gender = auth[:extra][:raw_info][:gender]
        student.profile_link = auth[:extra][:raw_info][:link]
        student.picture_link = auth[:extra][:raw_info][:picture]
        student.provider = auth[:provider]
        student.password = "password"
        
        student.confirmed = true

        if student.save
            classroom = Classroom.smarter_grades
            classroom.assign!(student)
            return student
        else
            $stderr.puts "STUDENT_ERRORS\n\t\t#{student.errors.full_messages.inspect}"
            return
        end
    end

    def self.create_badges(student)
        Badge.BadgeAPSD(student)
        Badge.BadgeNQCIARFTO(student,5)
        Badge.BadgeNQCIARFTO(student,10)
        Badge.BadgePSB(student)
        Badge.BadgePTB(student)
        Badge.BadgeCAPSWAD(student)
        Badge.BadgeTRQC(student)
        Badge.BadgeNPSB(student,5)
        Badge.BadgeNPSB(student,10)
        Badge.BadgeNQCIARFNT(student, 5, 5)
        Badge.BadgeNQCIARFNT(student, 5, 10)
        Badge.BadgeNQCIARFNT(student, 5, 15)
        Badge.BadgeNQCIARFNT(student, 10, 5)
        Badge.BadgeNQCIARFNT(student, 10, 10)
        Badge.BadgeNQCIARFNT(student, 10, 15)
    end

    def total_correct_wrong_answers
        answers = self.correct_answers
        correct_answers = answers.select{|v| v == true }.count 
        wrong_answers = answers.select{|v| v == false }.count 
        total_answers = answers.count 
        return [total_answers, correct_answers, wrong_answers]     
    end

    def correct_answers
        self.answers.pluck(:correct)
    end

    def correct_answers_problem_type(problem_type)
        self.answers.where("problem_type_id = ?", problem_type).pluck(:correct)
    end

    def problem_stats_correct_and_total(problem_type)
        self.problem_stats.where("problem_type_id = ?", problem_type).collect{|v| [v.correct, v.count]}.first
    end

    def problem_set_instances_problem_set(problem_set)
        self.problem_set_instances.find_by_problem_set_id(problem_set)
    end

    private

    def assign_class
        if !@class
            @class = Classroom.where(:name => "SmarterGrades 6").first
        end
        @class.assign!(self)
    end
end
