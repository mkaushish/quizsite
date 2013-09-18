class QuizInstancesController < ApplicationController

    before_filter :authenticate
    before_filter :validate_student_via_current_user
    before_filter :validate_problem_set_instances, :only => [:show]
    before_filter :validate_quiz, :only => [:show, :do_problem, :finish_problem, :finish_quiz]
    before_filter :validate_quiz_instance, :only => [:do_problem, :finish_problem, :finish_quiz]
    
    def show
        @title = "Quiz"
        @classroom = @student.classrooms.first
        if !@quiz.blank?
            @quiz_instance = @quiz.validate_quiz_instance(@pset_instance)
            @quiz_instance.start
            return finish_quiz if @quiz_instance.finished?
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
        respond_to do |format|
            format.html { render 'results' }
        end
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
        @quiz_instance = @quiz.quiz_instances.includes(:answers).find_by_id(params[:id])
        deny_access && return unless @quiz_instance.user_id == @student.id
    end
end
