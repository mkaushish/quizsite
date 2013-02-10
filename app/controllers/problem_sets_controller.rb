class ProblemSetsController < ApplicationController
  # GET /problem_sets/:name
  # problem_sets_path(:name)
  def show
    @problem_set = ProblemSet.find(params[:name])
    @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                         :user_id => current_user.id).first
    @instance ||= current_user.problem_set_instances.new(:problem_set => @problem_set)
    @stats = @instance.stats
    @sessions = []
    include_history @problem_set
  end

  def static_do
    @problem_set = ProblemSet.find(params[:name])
    @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                         :user_id => current_user.id).first
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

  def do
    @problem_set = ProblemSet.find(params[:name])
    @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                         :user_id => current_user.id).first
    # @instance ||= current_user.problem_set_instances.new(:problem_set => @problem_set)
    redirect_to access_denied_path && return if @instance.nil?

    if @problem_set.problem_types.exists? params[:pid]
      @problem_type = @problem_set.problem_types.find(params[:pid])
      @stat = @instance.stat(@problem_type)
      @problem = @stat.spawn_problem
      $stderr.puts "STAT_N_PROBLEM " * 20
      $stderr.puts @stat.inspect
      $stderr.puts @problem.inspect
    else
      redirect_to access_denied_path && return
    end
  end

  def problem_results
  end

  # POST /problem_sets/:name/finish_problem
  # ps_finish_problem_path(:name)
  def finish_problem
    @stat = ProblemSetStat.includes(:problem_set_instance).includes(:problem_type).find(params[:stat_id])
    redirect_to access_denied_path && return if @stat.user != current_user

    @instance = @stat.problem_set_instance
    @answer = current_user.answers.create params: params, session: @instance
    @stat.update!(@answer)

    @problem = @answer.problem.problem
    @solution = @problem.prefix_solve
    @response = @answer.response_hash

    render 'show_answer'
  end

  private
  # 
  # Sets the @history variable, which allows the partial 'problem_sets/_history' to be rendered
  #
  def include_history(problem_set, n = 11)
    return nil if current_user.nil?

    #instance = @instance || ProblemSetInstance.where(:problem_set_id => @problem_set.id,
    #                                                 :user_id => current_user.id).first
    #stats = (@stats || @instance.stats).map(&:id)
    generators = ProblemGenerator.where(:problem_type_id => problem_set.problem_types.map(&:id)).map(&:id)
    @history = current_user.answers.where(:problem_generator_id => generators)
                            .order("created_at DESC")
                            .includes(:problem)
                            .limit(n)
  end
end
