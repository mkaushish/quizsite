class ExplanationsController < ApplicationController
    
    before_filter :validate_original_problem

    def explain
        unless @orig_prob.explanation.blank?
            @explanation = @orig_prob.explanation
        else
            @i = SubproblemIterator.new(@orig_prob, "0")
            @problem = @i.cur
        end
    end

    def next_subproblem
        @i = SubproblemIterator.new(@orig_prob, params[:i])
        @attempts = params["attempts"].to_i
        @correct = @i.last_correct?(params)
        @problem = @i.cur
        @solution = @problem.prefix_solve
        @response = params
        if @correct || @attempts >= 1
            if @i.last?
                if @i.nested?
                    render 'contract'
                else
                    render 'finish'
                end
            else
                @i.increment
                # set up variables for the replacing the previous problem with the answer view
                @response = @solution unless @correct
                render 'next_subproblem'
            end
        else
            render 'redo_subproblem'
        end
    end

    def save_last_problem
        return if @last_prob.class <= Subproblem # we don't save any explicit subproblems
        problem = Problem.new(:problem => @last_prob)
        $stderr.puts "PROBLEM WAS NOT SAVED BITCHES!!!!"*10 unless problem.save
        answer = current_user.answers.new(:problem  => problem,
                                            :correct  => @last_prob.correct?(params),
                                            :response => problem.get_packed_response(params))
        unless answer.save
            $stderr.puts "ANSWER WAS NOT SAVE MOFOS!!!!"*10
        end
    end
  
    def expand
        @index = params[:index]
        @explain = explain_from_index(@orig_prob, "0:#{@index}")
        @subprob = @explain[0]
        # TODO handle failure
        $stderr.puts "EXPAAAAAANDING: #{params.inspect}"
    end

    def contract
        set_vars_from params
        @solution  = @last_prob.prefix_solve
        @response  = @solution
    end

    private
    def validate_original_problem
        @orig_prob = Problem.find(params[:id])
    end
end