class ProblemSetsController < ApplicationController
  def edit
    @chapters = ProblemSet.where(user_id: nil)
    @problem_set = ProblemSet.find(params[:id])
    @problem_types = @problem_set.problem_types
    @ptypes_hash = @problem_set.ptypes_hash
  end

  # during edit/new: load problem_types from another chapter
  def load_chapter
  end

  def update
    @problem_set = ProblemSet.find(params[:id])

    if @problem_set.owner != current_user
      @problem_set = @problem_set.clone_for(current_user)
    end

    @problem_set.update_attributes name: params[:name], 
                                   ptype_params: params[:problem_types]

    if @problem_set.save
      redirect_to details_path(id: params["class_id"], problem_set: @problem_set)
    else
    end
  end

  def create
    @problem_set = ProblemSet.find(params[:id])
  end

  def clone
    @problem_set = ProblemSet.find(params[:id])
  end

  def assign_to_class
    @problem_set = ProblemSet.find(params[:id])
  end
end
