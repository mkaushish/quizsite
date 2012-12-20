class ProblemSetsController < ApplicationController
  def show
    @problem_set = ProblemSet.find(params[:name])
    @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                         :user_id => current_user.id).first
    @instance ||= current_user.problem_set_instances.new(:problem_set => @problem_set)
    @stats = @instance.stats
    @sessions = []
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
    end

  end

  def problem_results

  def finish_problem
    @problem_set = ProblemSet.find(params[:name])
    @instance = ProblemSetInstance.where(:problem_set_id => @problem_set.id,
                                         :user_id => current_user.id).first
    redirect_to access_denied_path && return if @instance.nil?
  end
end
