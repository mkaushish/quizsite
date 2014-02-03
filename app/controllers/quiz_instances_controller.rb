class QuizInstancesController < ApplicationController

    before_filter :authenticate
    before_filter :validate_student_via_current_user
    before_filter :validate_quiz, :only => [:show, :do_problem, :finish_problem, :finish_quiz, :do_problem_quiz_type_2, :finish_problem_quiz_type_2, :skip_question, :update_time_taken]
    before_filter :validate_quiz_instance, :only => [:do_problem, :finish_problem, :finish_quiz, :do_problem_quiz_type_2, :finish_problem_quiz_type_2, :skip_question, :update_time_taken]
    before_filter :validate_problem_set_instances, :only => [:show]
    
    def show
        @title = "Quiz"
        @classroom = @student.classrooms.first
        if !@quiz.blank?
            @quiz_instance = @quiz.validate_quiz_instance(@pset_instance)
            @quiz_instance.start
            if @quiz_instance.finished?
                ( @quiz.quiz_type == 2 ) ? ( redirect_to finish_quiz_type_2_path(@quiz, @quiz_instance ) ) : ( return finish_quiz )
            end
            @counter = @quiz.quiz_problems.count - @quiz_instance.stats_remaining.count
            @quiz_stats = @quiz_instance.quiz_stats
            @all_badges = @student.all_badges
        else
            redirect_to pset_path(:name => @pset_instance.problem_set_id), notice: "No Quiz for you"
        end
    end

    def do_problem
        @title ||= "In Quiz"
        
        @counter = params[:c].to_i if defined? params[:c]
        @counter = 0 if !@counter.blank? and @counter <= 0 
        @counter ||= @quiz.quiz_problems.count - @quiz_instance.stats_remaining.count
        unless @quiz_instance.blank?
            @quiz_instance.start unless @quiz_instance.started?
            @problems = @quiz_instance.quiz_problems
            @problem = Problem.find_by_id(params[:problem_id]) if defined? params[:problem_id] and !params[:problem_id].blank?
            @problem ||= Problem.find_by_id(@problems[@counter].problem) unless @problems[@counter].nil?
            @problem ||= Problem.find_by_id(@quiz_instance.stats_remaining.first.problem_id)
            @problem_type = @problem.problem_type
            @stat = @quiz_instance.stats.find_by_problem_id(@problem.id)
            @stat ||= @quiz_instance.next_stat
            @quiz_stats = @quiz_instance.quiz_stats.includes(:problem_type)
            @pset = @quiz_instance.problem_set
            @all_badges = @student.all_badges
            @answers = @quiz_instance.answers
            @answer = @quiz_instance.answers.find_by_problem_id(@problem.id)
            unless @answer.blank?
                @response = @answer.response_hash
                @solution = @problem.problem.prefix_solve
                respond_to do |format|
                    format.html { render 'answers/show_quiz_ans' }
                end
            else
                respond_to do |format|
                    format.html
                end
            end
        else
            redirect_to pset_path(:name => @pset.id), notice: "No Quiz for you"
        end
    end

    def finish_problem
        @stat = @quiz_instance.quiz_stats.find(params[:stat_id])
        redirect_to access_denied_path && return if @stat.user != current_user
        @answer = @quiz_instance.answers.find_by_problem_id(params[:problem_id])
        @answer.destroy unless @answer.blank?
        @answer = @student.answers.create params: params, session: @quiz_instance
        @stat.update_w_ans!(@answer)
        @counter = @quiz.quiz_problems.count - @quiz_instance.stats_remaining.count
        @pset = @quiz_instance.problem_set
        @all_badges = @student.all_badges
        @answers = @quiz_instance.answers
        if !@quiz.blank?
            @response = @answer.response_hash
            @problem = @answer.problem
            @solution = @problem.problem.prefix_solve
            respond_to do |format|
                format.js { render 'answers/show_quiz_ans' }
            end
        else
            redirect_to pset_path(:name => @pset.id), notice: "No Quiz for you"
        end
    end
    
    def finish_quiz
        @title = "Quiz Results"
        @quiz ||= Quiz.find_by_id(params[:quiz_id])
        @quiz_instance ||= @quiz.quiz_instances.find_by_user_id(current_user)
        @quiz_instance.finish
        @pset = @quiz_instance.problem_set
        @answers = @quiz_instance.answers.includes(:problem_type)
        @problems_left = @quiz_instance.problems_left
        @all_badges = @student.all_badges
        @quiz_instance.send_submission_notification_to_teacher(@student)

        respond_to do |format|
            format.html { render 'results' }
        end
    end

    def do_problem_quiz_type_2
        @title ||= "In Quiz"
        @remaining = @quiz_instance.stats_remaining.count
        @counter = @quiz.quiz_problems.count - @remaining
        unless @quiz_instance.blank?
            @quiz_instance.start unless @quiz_instance.started?
            @problems = @quiz_instance.quiz_problems

            @problem = Problem.find_by_id(@problems[@counter].problem) unless @problems[@counter].nil?
            @problem_type = @problem.problem_type
            @stat = @quiz_instance.stats.find_by_problem_id(@problem.id)
            @stat ||= @quiz_instance.next_stat
            @pset = @quiz_instance.problem_set
            @quiz_instance.update_timer_and_last_visited
            respond_to do |format|
                format.html
                format.js
            end
        end
    end

    def finish_problem_quiz_type_2
        @stat = @quiz_instance.quiz_stats.find(params[:stat_id])
        redirect_to access_denied_path && return if @stat.user != current_user
        @answer = @quiz_instance.answers.find_by_problem_id(params[:problem_id])
        @answer ||= @student.answers.create params: params, session: @quiz_instance
        @stat.update_w_ans!(@answer)
        @quiz_instance.remaining_time -= params[:time_taken].to_i
        if @quiz_instance.stats_remaining.count == 0
            respond_to { |format| format.html { redirect_to finish_quiz_type_2_path(@quiz, @quiz_instance) and return } }
        end
        if params[:commit] == "Submit And Pause"
            @quiz_instance.last_visited_at = Time.now.utc
            @quiz_instance.paused = true
            respond_to { |format| format.html { redirect_to show_quiz_path(@quiz_instance.problem_set_instance_id, @quiz) }} if @quiz_instance.save
        else
            redirect_to do_quiz_problem_type_2_path(@quiz, @quiz_instance) if @quiz_instance.save
        end
    end

    def skip_question
        @stat = @quiz_instance.quiz_stats.find(params[:stat_id])
        redirect_to access_denied_path && return if @stat.user != current_user

        @stat.remaining -= 1
        current_user.points -= 50
        @quiz_instance.remaining_time -= params[:total_time_taken].to_i if defined? params[:total_time_taken]


        if @stat.save and current_user.save
            if defined? params[:pause] and params[:pause] == "true"
                @quiz_instance.last_visited_at = Time.now
                @quiz_instance.paused = true
                respond_to { |format| format.html { redirect_to show_quiz_path(@quiz_instance.problem_set_instance_id, @quiz) }} if @quiz_instance.save
            else
                redirect_to do_quiz_problem_type_2_path(@quiz, @quiz_instance) if @quiz_instance.save
            end
        end
    end

    def finish_quiz_type_2
        @title = "Quiz Results"
        @quiz ||= Quiz.find_by_id(params[:quiz_id])
        @quiz_instance ||= @quiz.quiz_instances.find_by_user_id(current_user)
        @quiz_instance.finish
        @quiz_instance.send_submission_notification_to_teacher(@student)

        respond_to do |format|
            format.html
            format.js
        end
    end

    def update_time_taken
        @quiz_instance.last_visited_at = Time.now
        @quiz_instance.save

        p "time here " + Time.now.to_s
        render :nothing => true
    end

    private

    def validate_student_via_current_user
        @student = current_user
    end

    def validate_student
        @student = Student.find_by_id(params[:student_id])
        redirect_to access_denied_path && return if @student != current_user
    end

    def validate_problem_set_instances
        @pset_instance = @student.problem_set_instances.find(params[:problem_set_instance_id])
    end

    def validate_quiz
        @quiz = Quiz.find_by_id(params[:quiz_id])
    end

    def validate_quiz_instance
        @quiz_instance = @quiz.quiz_instances.includes(:quiz_problems, :problem_set).find_by_id(params[:id])
        deny_access && return unless @quiz_instance.user_id == @student.id
    end

    def validate_problem_set_instances
        @pset_instance = @student.problem_set_instances.find(params[:problem_set_instance_id]) unless params[:problem_set_instances].nil?
        problem_set_id = @quiz.problem_set_id
        @pset_instance ||= @student.problem_set_instances_problem_set(@quiz.problem_set_id) if @student.is_assigned?(problem_set_id)
        deny_access && return if @pset_instance.blank?
    end
end