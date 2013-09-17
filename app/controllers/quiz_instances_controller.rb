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
            # return finish_quiz if @quiz_instance.over?
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
            @problem ||= Problem.find_by_id(@problems[@counter].problem)
            @problem_type = @problem.problem_type
            @stat = @quiz_instance.stats.find_by_problem_id(@problem.id)
            @stat ||= @quiz_instance.next_stat
            @quiz_stats = @quiz_instance.quiz_stats.includes(:problem_type)
            @pset = @quiz_instance.problem_set
            @all_badges = @student.all_badges
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

    def finish_quiz
        @title = "Quiz Results"
        @quiz ||= Quiz.find_by_id(params[:quiz_id])
        @quiz_instance ||= @quiz.quiz_instances.find_by_user_id(current_user)
        @quiz_instance.finish
        @pset = @quiz_instance.problem_set
        @answers = @quiz_instance.answers.includes(:problem_type)
        @all_badges = @student.all_badges
        respond_to do |format|
            format.html { render 'results' }
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
        if @quiz_instance.over?
            redirect_to show_quiz_path(@quiz_instance.problem_set_instance, @quiz)
        else
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
    end


    # GET quizzes/:id/start
    # start_quiz_path(@quiz)
    # def start
    #     @title = "Starting Quiz"
    #     @quiz_instance.start
    #     do_problem
    # end



    # def new
    #     @pset_instance = ProblemSetInstance.find(params[:id])
    #     deny_access && return unless belongs_to_user(@pset_instance)

    #     @classroom = @student.classrooms.first
    #     @quiz=Quiz.find_by_id(params[:quiz_id])
    #     if !@quiz.blank?
    #         @instance = @quiz.quiz_instances.where(:problem_set_instance_id => @pset_instance).last
    #         @instance ||= @quiz.assign_with_pset_inst(@pset_instance)
    #         @instance.start if !@instance.started?
    #         @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
    #         @quiz_stats = @instance.quiz_stats.includes(:problem_type)
    #         @pset = @instance.problem_set
    #         @problems = @instance.quiz_problems
    #         @all_badges = @student.all_badges
    #         next_problem
    #     else
    #         redirect_to pset_path(:name => @pset_instance.problem_set_id), notice: "No Quiz for you"
    #     end


    # end

    # GET /quizzes/:id/next_quiz_problem
    # # next_quiz_problem_path
    # def previous_problem
    #     @title ||= "In Quiz"
    #     @instance ||= QuizInstance.includes(:problem_set).find(params[:instance])
    #     @quiz = @instance.quiz
    #     deny_access && return unless @instance.user_id == current_user.id
    #     return finish_quiz if @instance.over?
    #     @counter = (params[:c].to_i - 2) if defined? params[:c]
    #     @counter ||= @quiz.quiz_problems.count - @instance.stats_remaining.count
    #     @all_badges = @student.all_badges
    #     unless @instance.blank?
    #         @problems = @instance.quiz_problems
    #         @counter = 0 if @counter <= 0
    #         @problem = Problem.find_by_id(@problems[@counter].problem)
    #         @problem_type = @problem.problem_type
    #         @stat = @instance.stats.find_by_problem_id(@problem.id)
    #         @answer = @instance.answers.find_by_problem_id(@problem.id)
    #         unless @answer.blank?
    #             @response = @answer.response_hash
    #             @solution = @problem.problem.prefix_solve
    #             respond_to do |format|
    #                 format.js { render 'answers/show_quiz_ans' }
    #             end
    #         else
    #             @quiz_stats = @instance.quiz_stats.includes(:problem_type)
    #             @pset = @instance.problem_set
    #             respond_to do |format|
    #                 format.html { render 'problem' }
    #                 format.js { render 'do' }
    #             end
    #         end
    #     else
    #         redirect_to pset_path(:name => @pset.id), notice: "No Quiz for you"
    #     end
    # end

    # # GET /quizzes/:id/next_quiz_problem
    # # next_quiz_problem_path
    # def next_problem
    #     @title ||= "In Quiz"
    #     @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
    #     @instance ||= QuizInstance.includes(:problem_set).find(params[:id])
    #     deny_access && return unless @instance.user_id == current_user.id
    #     return finish_quiz if @instance.over?
    #     unless @instance.blank?
    #         @problems = @instance.quiz_problems
    #         @problem = Problem.find_by_id(@problems[@counter].problem)
    #         @problem_type = @problem.problem_type
    #         @stat = @instance.stats.find_by_problem_id(@problem.id)
    #         @stat ||= @instance.next_stat
    #         @quiz_stats = @instance.quiz_stats.includes(:problem_type)
    #         @pset = @instance.problem_set
    #         @all_badges = @student.all_badges
    #         respond_to do |format|
    #             format.html { render 'problem' }
    #             format.js { render 'do' }
    #         end
    #     else
    #         redirect_to pset_path(:name => @pset.id), notice: "No Quiz for you"
    #     end
    # end

    
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
        @quiz_instance = @quiz.quiz_instances.find_by_id(params[:id])
        deny_access && return unless @quiz_instance.user_id == @student.id
    end
end
