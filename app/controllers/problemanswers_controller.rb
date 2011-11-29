require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'

class ProblemanswersController < ApplicationController
  # GET /problemanswers
  # GET /problemanswers.json
  def index
    @problemanswers = get_probs

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @problemanswers }
    end
  end

  # GET /problemanswers/1
  # GET /problemanswers/1.json
  def show
    @problemanswer = Problemanswer.find(params[:id])
		@problem = @problemanswer.problem.unpack
		@solution = @problem.prefix_solve
		@response = @problemanswer.response_hash

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @problemanswer }
    end
  end

  # GET /problemanswers/new
  # GET /problemanswers/new.json
  def new
		plist = get_probs
		plist = all_probs if plist.empty?
		ptype = plist.sample

		@problem = Problem.new
		@problem.my_initialize(ptype)
		@problem.save

		#$stderr.puts "#"*30 + "\n" + @problem.prob.text.inspect

		if flash[:last_correct] == false
			@last_prob = Problemanswer.find(flash[:last_id])
		end

		@problemanswer = Problemanswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @problemanswer }
    end
  end

  # GET /problemanswers/1/edit
  def edit
    @problemanswer = Problemanswer.find(params[:id])
  end

	def explain
		@bigproblem = Problem.find(params["problem_id"])
		if @bigproblem.is_a? QuestionWithExplanation
			@subproblems = @bigproblem.explain
		end
	end

  # POST /problemanswers
  # POST /problemanswers.json
  def create
		@problem = Problem.find(params["problem_id"])
		@problem.load_problem

		@problemanswer = Problemanswer.new(:problem => @problem, 
																			 :correct => @problem.correct?(params),
																			 :response => @problem.get_packed_response(params))

		if @problemanswer.save
			flash[:notice] = 'Problemanswer successsfully created' 
		else
			flash[:notice] = "THERE WAS AN ERRORR OH NOOOOOOOOOO Problemanswer wasn't created for some reason"
		end

		flash[:last_correct] = @problemanswer.correct
		flash[:last_id] = @problemanswer.id

		$stderr.puts "\n\n#{"#"*30}\n#{@problem.text}"
		$stderr.puts "#{@problem.prob.solve}"
		$stderr.puts "params = #{params.inspect}\n#{"#"*30}\n"

		# TODO FIX ME
		if @problemanswer.correct
			redirect_to :action => 'new'
		else
			redirect_to @problemanswer
		end
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
