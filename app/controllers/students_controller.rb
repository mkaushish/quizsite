class StudentsController < ApplicationController
    
    before_filter :authenticate, :except => [:show, :new, :create]
    before_filter :validate_student, :only => [:update, :show, :chart]
    before_filter :validate_student_via_current_user, :only => [:home, :edit]

    def home
        @pset_instances = @student.problem_set_instances.includes(:problem_stats, :problem_set, :problem_set_problems)
        @history = current_user.answers.order("created_at DESC").limit(11)
        Student.create_badges(@student)
        @badges = @student.badges
    end
    
    def show
        @problem_sets = @student.problem_sets.includes(:problem_types)
    end

    def new
        @student = Student.new
    end

    def create
        student = Student.new(params[:student])
        if !student.save
            $stderr.puts "STUDENT_ERRORS\n\t\t#{student.errors.full_messages.inspect}"
            $stderr.puts "FORM_FOR_ERRS:" + form_for_errs('student', student)
            render :js => form_for_errs('student', student)
            return
        end
        classroom = nil
        if params[:class_pass].empty?
            classroom = Classroom.smarter_grades
        else
            classroom = Classroom.find_by_password(params[:class_pass])
        end
        if classroom.nil?
            student.delete
            render :js => form_err_js(:class_pass, "Invalid class password")
            return
        end
        classroom.assign!(student)
        UserMailer.welcome_email(student).deliver
        sign_in student
        render :js => "window.location.href = '/'"
    end

    def edit
        respond_to do |format|
            format.js
        end
    end

    def update
        @old_pass = params['student']['old_password']
        @new_pass = params['student']['new_password']
        @confirm_pass = params['student']['confirm_password']
        @student.change_password(@old_pass, @new_pass, @confirm_pass)
        sign_in @student
        respond_to do |format|
            if @student.update_attributes(params[:student])
                format.html { redirect_to studenthome_path, notice: 'Your Profile is successfully updated.' }
            else
                format.html { render action: "edit" }
            end
        end
    end

    def me
    end

    def chart
        @problem_sets = @student.problem_sets
        # Percentage of correct answers by weekly
        @arr1 = [['Weeks Ago','% correct']]
        # Percentage of wrong answers by Chapter
        @arr2 = [['Chapters','Wrong Answers']]
        # Student performance chart by each problem set correct percentage 
        @arr3 = [['Chapters','Correct Percentage']]
        # Questions done in the particular week 
        @arr4 = [['Weeks Ago','Questions Done']]
        # Percentage of correct answer by student 
        @arr5 = [['Chapters','Questions Done']]
        i=51 
        
        while i >= 0 do 
            time_range = ( date_of_last( "Monday", (i+1).weeks.ago )..date_of_last( "Monday", i.weeks.ago )) 
            answers = @student.answers.where( "created_at BETWEEN ? and ?", time_range.first, time_range.last ).map(&:correct) 
            ans_right = answers.select{ |v| v == true }.count 
            ans_wrong = answers.select{ |v| v == false }.count 
            total_answers = answers.count 
            if total_answers == 0 
                @arr1.push( [(i+1).to_s, 0] ) 
            else 
                @arr1.push( [(i+1).to_s, (ans_right*100) / (total_answers)]) 
            end 
                @arr4.push([(i+1).to_s, total_answers])    
            i = i-1 
        end  
        
        time_range_for_arr5 = (2.weeks.ago..Time.now) 
        @student.problem_set_instances.each do |pset| 
            answers = pset.answers.map(&:correct) 
            ans_right = answers.select{|v| v == true}.count 
            ans_wrong = answers.select{|v| v == true}.count 
            ans = pset.answers.where("created_at BETWEEN ? and ?", time_range_for_arr5.first, time_range_for_arr5.last) 
            @arr5.push([pset.name, ans.count]) 
            if (ans_wrong + ans_right) > 0   
                @arr3.push([pset.name, (ans_right * 100) / (ans_right + ans_wrong)]) 
            end   
            @arr2.push([pset.name, ans_wrong]) 
        end 
    end   
    
    def problemset_chart
        @pset = ProblemSet.find_by_id(params[:pset])
        respond_to do |format|
            format.js 
        end 
    end

    private

    def validate_student
       @student = Student.find_by_id(params[:id])
    end

    def validate_student_via_current_user
        @student = current_user
    end
end