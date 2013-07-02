class Student < User

    attr_accessor :old_password, :new_password, :confirm_password
    attr_accessible :old_password, :new_password, :confirm_password
      
    has_many :classroom_assignments
    has_many :classrooms, :through => :classroom_assignments
    has_many :teachers, :through => :classrooms
    has_many :badges
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
    end

    private

    def assign_class
        if !@class
            @class = Classroom.where(:name => "SmarterGrades 6").first
        end
        @class.assign!(self)
    end
end
