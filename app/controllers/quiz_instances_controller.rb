class QuizInstancesController < ApplicationController

    before_filter :authenticate
    before_filter :validate_student

    # GET quizzes/:id/start
    # start_quiz_path(@quiz)
    def start
        @title = "Starting Quiz"
        @instance = QuizInstance.find(params[:instance])
        deny_access && return unless @instance.user_id == current_user.id
        return finish_quiz if @instance.over?
        @quiz = Quiz.find_by_id(@instance.quiz_id)
        @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
        @instance.start
        next_problem
    end

    def new
        @pset_instance = ProblemSetInstance.find(params[:id])
        deny_access && return unless belongs_to_user(@pset_instance)

        @classroom = @student.classrooms.first
        @quiz=Quiz.find_by_id(params[:quiz_id])
        if !@quiz.blank?
            @instance = @quiz.quiz_instances.where(:problem_set_instance_id => @pset_instance).last
            @instance ||= @quiz.assign_with_pset_inst(@pset_instance)
            @instance.start if !@instance.started?
            @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
            @quiz_stats = @instance.quiz_stats.includes(:problem_type)
            @pset = @instance.problem_set
            @problems = @instance.quiz_problems
            next_problem
        else
            redirect_to pset_path(:name => @pset_instance.problem_set_id), notice: "No Quiz for you"
        end
    end

    # GET /quizzes/:id/next_quiz_problem
    # next_quiz_problem_path
    def previous_problem
        @title ||= "In Quiz"
        @instance ||= QuizInstance.includes(:problem_set).find(params[:instance])
        @quiz = @instance.quiz
        deny_access && return unless @instance.user_id == current_user.id
        return finish_quiz if @instance.over?
        @counter = (params[:c].to_i - 2) if defined? params[:c]
        @counter ||= @quiz.quiz_problems.count - @instance.stats_remaining.count
        unless @instance.blank?
            @problems = @instance.quiz_problems
            @counter = 0 if @counter <= 0
            @problem = Problem.find_by_id(@problems[@counter].problem)
            @problem_type = @problem.problem_type
            @stat = @instance.stats.find_by_problem_id(@problem.id)
            @answer = @instance.answers.find_by_problem_id(@problem.id)
            unless @answer.blank?
                @response = @answer.response_hash
                @solution = @problem.problem.prefix_solve
                respond_to do |format|
                    format.js { render 'answers/show_quiz_ans' }
                end
            else
                @quiz_stats = @instance.quiz_stats.includes(:problem_type)
                @pset = @instance.problem_set
                respond_to do |format|
                    format.html { render 'problem' }
                    format.js { render 'do' }
                end
            end
        else
            redirect_to pset_path(:name => @pset.id), notice: "No Quiz for you"
        end
    end

    # GET /quizzes/:id/next_quiz_problem
    # next_quiz_problem_path
    def next_problem
        @title ||= "In Quiz"
        @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
        @instance ||= QuizInstance.includes(:problem_set).find(params[:id])
        deny_access && return unless @instance.user_id == current_user.id
        return finish_quiz if @instance.over?
        unless @instance.blank?
            @problems = @instance.quiz_problems
            @problem = Problem.find_by_id(@problems[@counter].problem)
            @problem_type = @problem.problem_type
            @stat = @instance.stats.find_by_problem_id(@problem.id)
            @stat ||= @instance.next_stat
            @quiz_stats = @instance.quiz_stats.includes(:problem_type)
            @pset = @instance.problem_set
            respond_to do |format|
                format.html { render 'problem' }
                format.js { render 'do' }
            end
        else
            redirect_to pset_path(:name => @pset.id), notice: "No Quiz for you"
        end
    end

    def finish_quiz
        @title = "Quiz Results"
        @instance ||= QuizInstance.find(params[:id])
        @instance.finish
        @pset = @instance.problem_set
        @answers = @instance.answers.includes(:problem_type)
        render 'results'
    end

    def finish_problem
        @stat = QuizStat.includes(:quiz_instance).find(params[:stat_id])
        redirect_to access_denied_path && return if @stat.user != current_user
        @instance = @stat.quiz_instance
        @quiz = Quiz.find_by_id(@instance.quiz_id)
        @answer = @instance.answers.find_by_problem_id(params[:problem_id])
        @answer.destroy unless @answer.blank?
        @answer = current_user.answers.create params: params, session: @instance
        @stat.update_w_ans!(@answer)
        @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
        @pset = @instance.problem_set
        if @instance.over?
            finish_quiz
        else
            if !@quiz.blank?
                next_problem
            else
                redirect_to pset_path(:name => @pset.id), notice: "No Quiz for you"
            end
        end
    end

    private

    def validate_student
        @student = current_user

    end
end
