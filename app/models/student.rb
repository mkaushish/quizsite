class Student < User

    attr_accessor :old_password, :new_password, :confirm_password
    attr_accessible :old_password, :new_password, :confirm_password, :badges_count
      
    has_many :classroom_assignments
    has_many :classrooms, :through => :classroom_assignments
    
    has_many :teachers, :through => :classrooms
    has_many :notifications
    
    has_many :relationships, :dependent => :destroy
    has_many :coaches, :through => :relationships
    
    has_many :badges
    
    has_many :merits_comment, :class_name => "Badge", 
                        :conditions => "comment_id IS NOT NULL AND answer_id IS NULL",
                        :dependent => :destroy
    has_many :merits_answer, :class_name => "Badge", 
                        :conditions => "answer_id IS NOT NULL AND comment_id IS NULL",
                        :dependent => :destroy
    has_many :merits_simple, :class_name => "Badge", 
                        :conditions => "teacher_id IS NOT NULL AND comment_id IS NULL AND answer_id IS NULL",
                        :dependent => :destroy

    # after_create :assign_class #TODO broken

    def problem_history(*ptypes)
        ptypes_list = ptypes
        if ptypes[0].is_a? Array
            ptypes_list = ptypes[0]
        end
        answers.where(problem_type_id: ptypes_list).includes(:problem_type).order("created_at DESC")
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
        chart_data_1 = [['Weeks Ago','Correct Percentage']]
        # Percentage of wrong answers by Chapter
        chart_data_2 = [['Chapters','Wrong Answers']]
        # Student performance chart by each problem set correct percentage 
        chart_data_3 = [['Chapters','Correct Percentage']]
        # Questions done in the particular week 
        chart_data_4 = [['Weeks Ago','Questions Done']]
        # Student performance chart by each problem type correct percentage 
        chart_data_5 = [['Problem Types','Correct Percentage']]

        i = self.get_weeks_count 
        total_weeks = i
        while i >= 0 do 
            # time_range = ( date_of_last( "Monday", (i+1).weeks.ago )...date_of_last( "Monday", i.weeks.ago )) 
            answers = self.answers_correct_in_time_range( ( i ).weeks.ago.beginning_of_week, ( i ).weeks.ago.end_of_week )            
            ans_right = answers.select{ |v| v == true }.count 
            ans_wrong = answers.select{ |v| v == false }.count 
            total_answers = answers.count 
            if total_answers == 0 
                chart_data_1.push( [ "Week " + ( total_weeks - i + 1 ).to_s, 0 ] ) 
            else 
                chart_data_1.push( [ "Week " + ( total_weeks - i + 1 ).to_s, ( ans_right * 100 ) / ( total_answers ) ] ) 
            end 
                chart_data_4.push( [ "Week " + ( total_weeks - i + 1 ).to_s, total_answers ] )    
            i = i - 1 
        end  
        _problem_type_answers = []
        self.problem_set_instances.each do |pset_instance| 
            answers = pset_instance.answers.find( :all , select: [ :correct, :problem_type_id ], order: :problem_type_id , :include => :problem_type).map{ |v| [ v.problem_type_id, v.problem_type.name, v.correct ] }
            total_answers   = answers.count
            ans_right       = answers.count{ |v| v[2] == true }
            ans_wrong       = answers.count{ |v| v[2] == false }


            if (total_answers) > 0   
                chart_data_3.push([pset_instance.name, (ans_right * 100) / (total_answers)]) 
                _problem_type_answers.push answers
            end   
            chart_data_2.push([pset_instance.name, ans_wrong])
        end
        _problem_type_answers = _problem_type_answers.flatten(1)
        _problem_type_ids = _problem_type_answers.collect{ |v| v[0] }.uniq
        _problem_type_ids.each { |problem_type_id| chart_data_5.push [_problem_type_answers.select{ |u| u[0] == problem_type_id }.first[1], ( ( _problem_type_answers.select{ |u| u[0] == problem_type_id }.count{ |u| u[2] == true } * 100 ) / _problem_type_answers.select{ |u| u[0] == problem_type_id }.count ) ]}
        return [chart_data_1, chart_data_2, chart_data_3, chart_data_4, chart_data_5]
    end
    
    def total_correct_wrong_answers(start_time, end_time)
        if !start_time.nil? and !end_time.nil?
            answers = self.answers_correct_in_time_range(start_time, end_time)
        elsif !start_time.nil? and end_time.nil?
            answers = self.answers_correct_after_time(start_time)
        else
            answers = self.answers_correct
        end
        correct_answers = answers.count{ |v| v == true }
        wrong_answers = answers.count{ |v| v == false }
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
        instance = self.problem_set_instances.find_by_problem_set_id(problem_set)
        instance ||= self.problem_set_instances.new(:problem_set => problem_set)
    end

    def answers_correct_in_time_range(start_time, end_time)
        self.answers.where( "created_at BETWEEN ? and ?", start_time, end_time ).order("created_at DESC").pluck(:correct) 
    end

    def answers_correct_after_time(start_time)
        self.answers.where( "created_at BETWEEN ? and ?", start_time, Time.now ).order("created_at DESC").pluck(:correct) 
    end

    def problem_set_instances_num_problem_problem_stats_blue
        result = Array.new
        self.problem_set_instances.order("id").includes(:problem_set, :problem_stats).each do |pset_instance|
           result = result.push [(pset_instance.name), (pset_instance.num_problems - pset_instance.num_blue == 0), (pset_instance.num_problems - pset_instance.num_blue), (pset_instance.stop_green)]
        end
        return result
    end

    def problem_types_blue_name
        problem_type_name = Array.new
        self.problem_set_instances.order("id").includes(:problem_stats).each do |pset_instance|
            pset_instance.problem_stats.includes(:problem_type).blue.each do |problem_stat|
                problem_type_name = problem_type_name.push problem_stat.problem_type.name
            end
        end
        return problem_type_name
    end

    def all_quizzes(classroom, problem_set)
        quiz = Quiz.where("problem_set_id = ? AND classroom_id IS NULL", problem_set)
        quiz_with_classroom = (self.classrooms.first.quizzes).where("problem_set_id = ?", problem_set)
        quiz_with_classroom.each do |qws|
            if qws.students.blank?
                quiz.push qws
            else
                if qws.students.include? self.id.to_s
                    quiz.push qws 
                end
            end
        end
        return quiz
    end

    def all_quizzes_without_problemset
        quiz = Quiz.where("classroom_id IS NULL")
        quiz_with_classroom = self.classrooms.first.quizzes
        quiz_with_classroom.each do |qws|
            if qws.students.blank?
                quiz.push qws
            else
                quiz.push qws if qws.students.include? self.id.to_s
            end
        end
        return quiz
    end
    
    def is_assigned?(problem_set_id)
        self.problem_sets.pluck(:problem_set_id).include?(problem_set_id.to_s)
    end

    def get_weeks_count
        _created_at = self.created_at.to_date
        _created_at_week = _created_at.cweek
        _weeks = 52-_created_at_week
        _time_now_week = Time.now.utc.to_date.cweek
        _year_diff = Time.now.utc.to_date.year - _created_at.year
        unless _year_diff == 1
            _weeks += (_year_diff - 1) * 52
        end
        _weeks += _time_now_week
        return _weeks
    end

    private

    def assign_class
        if !@class
            @class = Classroom.where(:name => "SmarterGrades 6").first
        end
        @class.assign!(self)
    end

    # def date_of_last(day,date)
    #     newdate  = Date.parse(day)
    #     delta = newdate > date.to_date ? 0 : 7
    #     newdate + delta - 7
    # end
end