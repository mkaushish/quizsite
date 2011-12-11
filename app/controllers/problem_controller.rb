require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'

class ProblemController < ApplicationController
  def index
    @problems = get_probs
  end
    
  def choose
    @chosen_probs = get_probs
    @all_probs = all_probs
  end

  def explain
    @problem = Problem.find(params[:id])
    @explain = @problem.unpack.explanation
    @i = 0 # starting subproblem
  end

  def next_subproblem
    $stderr.puts "HEY I'M GETTING CALLED GUYS!"
    @problem = Problem.find(params[:problem_id])
    @explain = @problem.unpack.explanation
    @i = params[:subproblem_index].to_i
    if @explain[@i].correct?(params)
      @i += 1
      if @explain.length == @i
        $stderr.puts "Good job, you're done!"
        # TODO redirect somewhere else... 
        render :js => "window.location = '/'"
      else
        $stderr.puts "you got the last subproblem right!, moving on to #{@i}"
        respond_to { |format| format.js }
      end
    else
      $stderr.puts "you missed the last subproblem, try again!" 
      render :nothing => true
    end
  end

  def makequiz
    $stderr.puts params.inspect

    session_problems = []
    all_probs.each do |prob|
      if params[prob.to_s] == "1"
        session_problems << prob
      end
    end

    set_probs(session_problems)
    flash[:notice] = "you just set your problems"

    redirect_to :action => :index
  end
end
