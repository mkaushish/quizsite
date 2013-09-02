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
        answers.where(:problem_type_id => ptypes_list).order("created_at DESC").includes(:problem)
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

    def create_badges(pset, ptype)
        Badge.get_badges(self, pset, ptype)
    end

    def all_badges
        Badge.all_badges(self)
    end

    def charts_combine
        # Percentage of correct answers by weekly
        chart_data_1 = [['Weeks Ago','% correct']]
        # Percentage of wrong answers by Chapter
        chart_data_2 = [['Chapters','Wrong Answers']]
        # Student performance chart by each problem set correct percentage 
        chart_data_3 = [['Chapters','Correct Percentage']]
        # Questions done in the particular week 
        chart_data_4 = [['Weeks Ago','Questions Done']]
        i=51 
        
        while i >= 0 do 
            time_range = ( date_of_last( "Monday", (i+1).weeks.ago )..date_of_last( "Monday", i.weeks.ago )) 
            answers = self.answers_correct_in_time_range(time_range.first, time_range.last)            
            ans_right = answers.select{ |v| v == true }.count 
            ans_wrong = answers.select{ |v| v == false }.count 
            total_answers = answers.count 
            if total_answers == 0 
                chart_data_1.push( [(i+1).to_s, 0] ) 
            else 
                chart_data_1.push( [(i+1).to_s, (ans_right*100) / (total_answers)]) 
            end 
                chart_data_4.push([(i+1).to_s, total_answers])    
            i = i-1 
        end  
        
        self.problem_set_instances.each do |pset_instance| 
            answers = pset_instance.total_correct_wrong_problem_set_instance_answers
            total_answers = answers[0]
            ans_right = answers[1]
            ans_wrong = answers[2]
            if (total_answers) > 0   
                chart_data_3.push([pset_instance.name, (ans_right * 100) / (total_answers)]) 
            end   
                chart_data_2.push([pset_instance.name, ans_wrong])
        end
        return [chart_data_1, chart_data_2, chart_data_3, chart_data_4]
    end
    
    def total_correct_wrong_answers
        answers = self.answers_correct
        correct_answers = answers.select{|v| v == true }.count 
        wrong_answers = answers.select{|v| v == false }.count 
        total_answers = answers.count 
        return [total_answers, correct_answers, wrong_answers]     
    end

    def answers_correct
        self.answers.order("created_at DESC").pluck(:correct)
    end

    def answers_correct_with_problem_type_id
        self.answers.order("created_at DESC").collect{ |v| [v.correct, v.problem_type_id] }
    end

    def answers_correct_problem_type(problem_type)
        self.answers.where("problem_type_id = ?", problem_type).pluck(:correct)
    end

    def problem_stats_correct_and_total(problem_type)
        count=self.problem_stats.where("problem_type_id = ?", problem_type).collect{|v| [v.correct, v.count]}.first
        if count.nil?
            return [0,0]
        end
        count
    end

    def problem_set_instances_problem_set(problem_set)
        self.problem_set_instances.find_by_problem_set_id(problem_set)
    end

    def answers_correct_in_time_range(start_time, end_time)
        self.answers.where( "created_at BETWEEN ? and ?", start_time, end_time ).pluck(:correct) 
    end

    def problem_set_instances_num_problem_problem_stats_blue
        @result = Array.new
        self.problem_set_instances.order("id").includes(&:problem_stats).each do |pset_instance|
           @result = @result.push [(pset_instance.name), (pset_instance.num_problems - pset_instance.problem_stats.blue.count == 0), (pset_instance.num_problems - pset_instance.problem_stats.blue.count), (pset_instance.stop_green)]
        end
        return @result
    end

    def problem_types_blue_name
        @problem_type_name = Array.new
        self.problem_set_instances.order("id").each do |pset_instance|
            pset_instance.problem_stats.blue.each do |problem_stat|
                @problem_type_name = @problem_type_name.push problem_stat.problem_type.name
            end
        end
        return @problem_type_name
    end

    private

    def assign_class
        if !@class
            @class = Classroom.where(:name => "SmarterGrades 6").first
        end
        @class.assign!(self)
    end

    def date_of_last(day,date)
        newdate  = Date.parse(day)
        delta = newdate > date.to_date ? 0 : 7
        newdate + delta - 7
    end
end
