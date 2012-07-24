class ProblemController < ApplicationController
  include ProblemHelper

  def explain
    @orig_prob = Problem.find(params[:id])
    @explain = @orig_prob.unpack.explanation
    @i = 0 # starting subproblem

    @problem = @explain[@i]
  end

  def next_subproblem
    #$stderr.puts "HEY I'M GETTING CALLED GUYS!"
    set_vars_from params
    
    @nested = @index.count(":") > 0
    @solution = @last_prob.prefix_solve
    @response = @last_prob.get_useful_response(params)

    if @last_prob.correct?(params) || params["times_attempted"].to_i > 1

      # if we're at the end of a subproblem or the real problem
      if @explain.length == (@i + 1)
        # $stderr.puts "Good job, you're done!"

        if signed_in?

          # end of subproblem
          if @nested
            @index.gsub! /[^:]:/, ""
            @explain = explain_from_index(@orig_prob, @index)
            @i = @index.split(":")[0].to_i
            @last_prob = @explain[@i]
            @solution = @last_prob.prefix_solve
            @response = @solution

            render 'contract'

          # end of main problem
          else
            if in_quiz?
              increment_problem(true) # count correct if they go through the explanation
              render :js => "window.location.href = '/startquiz'"
            else
              render :js => "window.location = '/profile'"
            end
          end

        # doing the estimate example problem
        else
          render :js => "window.location = '/estimate'"
        end

      # still in the middle of an explanation, so increment counters and move on
      else
        @i += 1
        @subprob = @explain[@i]
        @index   = "#{@i}#{@index.sub(/[^:]*/, "")}"
        $stderr.puts "you got the last subproblem right!, moving on to #{@i}"
        render 'next_subproblem'
      end

    # missed the last subproblem
    else
      $stderr.puts "you missed the last subproblem, rendering wrong_subproblem" 
      render 'wrong_subproblem'
    end
  end

  def expand
    @orig_prob = Problem.find(params[:id])
    @index     = params[:index]
    @explain   = explain_from_index(@orig_prob, "0:#{@index}")
    @subprob   = @explain[0]

    # TODO handle failure

    $stderr.puts "EXPAAAAAANDING: #{params.inspect}"
  end

  def contract
    set_vars_from params

    @solution  = @last_prob.prefix_solve
    @response  = @solution
  end

  private

  # This sets several variables that are used in contract, expand, and next_subproblem
  # - note that all of these controller actions are passed the same form from the view
  def set_vars_from(params)
    @index  = params[:subproblem_index]
    @i      = @index.split(":")[0].to_i

    @orig_prob = Problem.find(params[:problem_id])
    @explain   = explain_from_index @orig_prob, @index
    @last_prob = @explain[@i]
  end

  # USED BY expand and next_subproblem
  # returns the (possibly nested) EXPLANATION for a problem and an index string
  # orig = the problem whose explanation we're going through
  # index = string of indices separated by semicolons
  def explain_from_index(orig, index)
    ret = orig.prob
    index.split(":").drop(1).reverse_each do |i|
      ret = ret.explain[i.to_i]
    end
    ret.explain
  end
end
