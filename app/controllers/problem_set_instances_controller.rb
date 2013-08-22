class ProblemSetInstancesController < ApplicationController
  
    before_filter :validate_student
    before_filter :validate_problem_set, :only => [:show, :static_do, :do]
    before_filter :validate_instance, :only => [:show, :static_do, :do]

    # GET /psets/:name
    # psets_path(:name)
    def show
        @problem_set = ProblemSet.includes(:problem_types).find(params[:name])
        @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                                :user_id => current_user.id).first
        @instance ||= current_user.problem_set_instances.new(:problem_set => @problem_set)
        @stats = @instance.stats
        @sessions = []
        @history = current_user.problem_history(@problem_set.problem_types.map(&:id)).limit(11)
        @all_badges = @student.all_badges
        @quiz = Quiz.where("problem_set_id = ? AND classroom_id IS NULL", @problem_set.id)
        @quiz_with_classroom = (current_user.classrooms.first.quizzes).where("problem_set_id = ?", @problem_set.id)
        @quiz_with_classroom.each do |qws|
            if qws.students.blank?
                @quiz.push qws
            else
                @quiz.push qws if qws.students.include? current_user.id.to_s
            end
        end
    end

    def static_do
        # @instance ||= current_user.problem_set_instances.new(:problem_set => @problem_set)
        redirect_to access_denied_path && return if @instance.nil?
        if @problem_set.problem_types.exists? params[:pid]
            @problem_type = @problem_set.problem_types.find(params[:pid])
            @stat = @instance.stat(@problem_type)
            @problem = @stat.spawn_problem
            render 'static_do', layout: false
        else
            redirect_to access_denied_path && return
        end
    end

    def problem_results
    end

    def do
        # @instance ||= current_user.problem_set_instances.new(:problem_set => @problem_set)
        redirect_to access_denied_path && return if @instance.nil?
        if @problem_set.problem_types.exists? params[:pid]
            @problem_type = @problem_set.problem_types.find(params[:pid])
            @stat = @instance.stat(@problem_type)
            @problem_stat = @stat.problem_stat
            if Time.now.utc >= @problem_stat.stop_green and @problem_stat.points > @problem_stat.points_required
                @problem_stat.set_new_points
            end
            @problem = @stat.spawn_problem
            # $stderr.puts "STAT_N_PROBLEM " * 20
            # $stderr.puts @stat.inspect
            # $stderr.puts @problem.inspect
        else
            redirect_to access_denied_path && return
        end
    end

    # POST /problem_sets/:name/finish_problem
    # finish_ps_problem_path(:name)
    def finish_problem
        @stat = ProblemSetStat.includes(:problem_set_instance).includes(:problem_type).find(params[:stat_id])
        redirect_to access_denied_path && return if @stat.user != current_user

        
        @instance = @stat.problem_set_instance
        # create answer
        @answer = current_user.answers.create params: params, session: @instance
        # update stats around answer - also modifies @answer but saves
        @stat.update_w_ans!(@answer)
        # updating the number of counts of each color type
        @instance.num_blue = @instance.problem_stats.blue.count
        @instance.num_green = @instance.problem_stats.green.count
        @instance.num_red = @instance.problem_stats.count - @instance.num_blue - @instance.num_green
        @instance.last_attempted = Time.now
        @instance.save
        @problem = @answer.problem.problem
        @solution = @problem.prefix_solve
        @response = @answer.response_hash
        @changedPoints = @answer.points
        @student.create_badges
        @all_badges = @student.all_badges
        render 'show_answer', locals: {callback: 'problem_set_instances/finish_problem'}
    end

    private
    # Sets the @history variable, which allows the partial 'problem_sets/_history' to be rendered
    def include_history(problem_set, n = 11)
        return nil if current_user.nil?
        generators = ProblemGenerator.where(:problem_type_id => problem_set.problem_types.map(&:id)).map(&:id)
        @history = current_user.answers.where(:problem_generator_id => generators)
                            .order("created_at DESC")
                            .includes(:problem)
                            .limit(n)
    end

    def validate_student
        @student = current_user
    end

    def validate_problem_set
        @problem_set = ProblemSet.includes(:problem_types).find(params[:name])
    end
    
    def validate_instance
        @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                            :user_id => current_user.id).first
    end
end