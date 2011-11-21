require 'c1'

class ProblemanswersController < ApplicationController
  # GET /problemanswers
  # GET /problemanswers.json
  def index
    @problemanswers = Problemanswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @problemanswers }
    end
  end

  # GET /problemanswers/1
  # GET /problemanswers/1.json
  def show
    @problemanswer = Problemanswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @problemanswer }
    end
  end

  # GET /problemanswers/new
  # GET /problemanswers/new.json
  def new
		ptype = Chapter1::PROBLEMS.sample
		@problem = Problem.new
		@problem.my_initialize(ptype)
		@problem.save

    @problemanswer = Problemanswer.new
		flash[:problem_id] = @problem.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @problemanswer }
    end
  end

  # GET /problemanswers/1/edit
  def edit
    @problemanswer = Problemanswer.find(params[:id])
  end

  # POST /problemanswers
  # POST /problemanswers.json
  def create
		@problem = Problem.find(flash[:problem_id])
		@problem.load_problem

		# TODO use hidden field not flash
		if @problem.correct?(params)
			flash[:notice] = "You got the last question right!"
		else
			flash[:notice] = "You missed the last question"
		end

		$stderr.puts "\n\n#{"#"*30}\n#{@problem.text}"
		$stderr.puts "#{@problem.prob.solve}"
		$stderr.puts "params = #{params.inspect}\n#{"#"*30}\n"
		redirect_to :action => 'new'
    #respond_to do |format|
    #  if @problemanswer.save
    #    format.html { redirect_to @problemanswer, notice: 'Problemanswer was successfully created.' }
    #    format.json { render json: @problemanswer, status: :created, location: @problemanswer }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @problemanswer.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PUT /problemanswers/1
  # PUT /problemanswers/1.json
  def update
    @problemanswer = Problemanswer.find(params[:id])

    respond_to do |format|
      if @problemanswer.update_attributes(params[:problemanswer])
        format.html { redirect_to @problemanswer, notice: 'Problemanswer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @problemanswer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problemanswers/1
  # DELETE /problemanswers/1.json
  def destroy
    @problemanswer = Problemanswer.find(params[:id])
    @problemanswer.destroy

    respond_to do |format|
      format.html { redirect_to problemanswers_url }
      format.json { head :ok }
    end
  end
end
