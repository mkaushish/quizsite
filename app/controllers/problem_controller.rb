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
		all_probs
		@chosen_probs = get_probs
		$stderr.puts "#"*50 + "\n" + @chosen_probs[0].inspect
  end

	def makequiz
		all_probs
		$stderr.puts params.inspect

		session_problems = []
		@problems.each do |prob|
			if params[prob.to_s] == "1"
				session_problems << prob
			end
		end

		set_probs(session_problems)
		flash[:notice] = "you just set your problems"

		redirect_to :action => :index
	end

	def explain
		@problem = Problem.find(params[:id])
	end
end
