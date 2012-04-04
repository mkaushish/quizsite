require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'

class ProblemController < ApplicationController
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
        #render :js => "window.location = '/'"
        if signed_in?
          #redirect_to quiz_path
          render :js => "window.location = '/quiz'"
        else
          #redirect_to estimate_path
          render :js => "window.location = '/estimate'"
        end
      else
        $stderr.puts "you got the last subproblem right!, moving on to #{@i}"
        respond_to { |format| format.js }
      end
    else
      $stderr.puts "you missed the last subproblem, try again!" 
      render :nothing => true
    end
  end
end
