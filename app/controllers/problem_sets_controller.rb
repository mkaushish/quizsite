class ProblemSetsController < ApplicationController
  def edit
    @chapters = ProblemSet.master_sets_with_ptypes
    @problem_set = ProblemSet.find(params[:id])
    @problem_types = @problem_set.problem_types

    # figure out the chapter that is starting out open in the tabs
    @open_chapter = nil
    @chapters.each do |chapter|
      chapter.problem_types.each do |ptype|
        if ptype.id == @problem_types.first.id
          @open_chapter = chapter
        end
      end
      break if @open_chapter
    end

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
