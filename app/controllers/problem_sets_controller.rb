class ProblemSetsController < ApplicationController
    
    before_filter :authenticate, :except => [:show, :view]
    before_filter :authenticate_admin, :only => [:edit_pset, :update_pset]
    before_filter :validate_problem_set, :only => [:update, :create, :clone, :assign_to_class, :view, :edit_pset, :update_pset] 
    before_filter :validate_teacher, :only => [:index, :new]

    def index
        @my_problem_sets =ProblemSet.where("user_id = ?", @teacher.id)
        @sg_problem_sets = ProblemSet.master_sets_with_ptypes
        respond_to do |format|
            format.html
        end
    end
    
    def show
        @problem_set = ProblemSet.includes(:problem_types).find(params[:id])
    end

    def new
        @chapters = ProblemSet.master_sets_with_ptypes
        
        @problem_set = @teacher.problem_sets.new
        @problem_types = @problem_set.problem_types
        
        # figure out the chapter that is starting out open in the tabs
        @open_chapter = @chapters.first
        
        @ptypes_hash = @problem_set.ptypes_hash
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
    end

    def clone
    end

    def assign_to_class
    end

    def view
    end

    def edit_pset
    end

    def update_pset
        respond_to do |format|
            if @problem_set.update_attributes(params[:post]) 
             
                format.html { redirect_to view_problem_set_path(@problem_set), notice: 'ProblemSet was successfully updated.' }
            else
                format.html { render action: "edit_pset" }
            end
        end
    end

    private
    # Filter for validating Problem Set #
    def validate_problem_set
        @problem_set = ProblemSet.find(params[:id]) 
    end

    def validate_teacher
        @teacher = Teacher.find_by_id(params[:id])
    end
end