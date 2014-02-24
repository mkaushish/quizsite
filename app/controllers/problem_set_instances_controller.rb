class ProblemSetInstancesController < ApplicationController
  
    before_filter :validate_student
    before_filter :validate_problem_set, :only => [:show, :do]
    before_filter :validate_instance, :only => [:show, :do]

    # GET /psets/:name
    # psets_path(:name)
    def show
        @classroom = @student.classrooms.first
        @stats = @instance.stats
        @sessions = []
        @history = @student.problem_history(@problem_set.problem_types.pluck(:id)).limit(11)
        @quiz = @student.all_quizzes(@classroom, @problem_set) if @instance.blue?
        @random_stat = @stats.sample
        @random_problem_type = @random_stat.problem_type_id
    end

    def do
        redirect_to access_denied_path && return if @instance.nil?
        if defined? params[:random_problem_start]
            if params[:random_problem_start] == "true"
                @problem_type = @problem_set.problem_types.sample
            end 
        end

        @problem_type ||= @problem_set.problem_types.find(params[:pid]) if defined? params[:pid]
        @stat = @instance.stat(@problem_type)
        @problem_stat = @stat.problem_stat
        if Time.now.utc >= @problem_stat.stop_green and @problem_stat.points > @problem_stat.points_required
            @problem_stat.set_new_points
        end
        @problem = @stat.spawn_problem
    end

    # POST /problem_sets/:name/finish_problem
    # finish_ps_problem_path(:name)
    def finish_problem
        @stat = ProblemSetStat.includes(:problem_set_instance).includes(:problem_type).find(params[:stat_id])
        redirect_to access_denied_path && return if @stat.user != @student
        if(@student.answers.find_by_problem_id(params[:problem_id].to_i).nil?)
            @instance = @stat.problem_set_instance
            @answer = @student.answers.create params: params, session: @instance
            @random_problem = params[:random] if defined? params[:random]
            @random_problem ||= "false"
            @stat.update_w_ans!(@answer, @random_problem)
            @instance.update_instance!
            @problem = @answer.problem.problem
            @solution = @problem.prefix_solve
            @response = @answer.response_hash
            @changedPoints = @answer.points
            @student.delay.create_badges(@instance.problem_set, @stat.problem_type.id)
            # @all_badges = @student.all_badges
            @comments = @answer.comments.includes(:user)
            @comment = Comment.new
           
        else
            render 'shared/nothing', remote: :true
        end
    end


    # def problem_results
    # end

    private
    # Sets the @history variable, which allows the partial 'problem_sets/_history' to be rendered
    # def include_history(problem_set, n = 11)
    #     return nil if current_user.nil?
    #     generators = ProblemGenerator.where(:problem_type_id => problem_set.problem_types.map(&:id)).map(&:id)
    #     @history = current_user.answers.where(:problem_generator_id => generators)
    #                         .order("created_at DESC")
    #                         .includes(:problem)
    #                         .limit(n)
    # end

    def validate_student
        @student = current_user
    end

    def validate_problem_set
        @problem_set = ProblemSet.includes(:problem_types).find_by_id(params[:id])
    end
    
    def validate_instance
        @instance = @student.problem_set_instances_problem_set(@problem_set)
    end
end