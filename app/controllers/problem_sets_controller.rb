class ProblemSetsController < ApplicationController
  def show
    @problem_set = ProblemSet.includes(:problem_types).find(params[:id])
  end

  def edit
    @chapters = ProblemSet.master_sets_with_ptypes
    @problem_set = ProblemSet.includes(:problem_types).find(params[:id])
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

    @problem_set.name = params[:problem_set][:name]
    @problem_set.problem_types = ProblemType.where(:id => params[:problem_types].keys)

    if @problem_set.save
      # TODO make this somehow track the classroom/possibly assign the problem set
      back_link = details_path
      render 'show'
    else
      render 'edit'
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
