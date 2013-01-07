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

    include_history
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
    else
      redirect_to access_denied_path && return
    end
  end

  def problem_results
  end

  # POST /problem_sets/:name/finish_problem
  # ps_finish_problem_path(:name)
  def finish_problem
    @problem_set = ProblemSet.find(params[:name])
    @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                         :user_id => current_user.id).first
    redirect_to access_denied_path && return if @instance.nil?

    @problem_type = @problem_set.problem_types.where(:id => params[:problem_type_id]).first
    
    # redirect_to TODO path && return if @problem_type.nil?

    @stat = @instance.stat(@problem_type)
    @stat.update!(params)

    redirect_to problem_sets_path(@problem_set.id)
  end

  private
  # 
  # Sets the @history variable, which allows the partial 'problem_sets/_history' to be rendered
  #
  def include_history(n = 11)
    problem_set = ProblemSet.find(params[:name])

    return nil if current_user.nil?

    #instance = @instance || ProblemSetInstance.where(:problem_set_id => @problem_set.id,
    #                                                 :user_id => current_user.id).first
    #stats = (@stats || @instance.stats).map(&:id)
    generators = ProblemGenerator.where(:problem_type_id => problem_set.problem_types.map(&:id)).map(&:id)
    @history = current_user.problemanswers.where(:problem_generator_id => generators)
                            .order("created_at DESC")
                            .includes(:problem)
                            .limit(n)
  end
end
