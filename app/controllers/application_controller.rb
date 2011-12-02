require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper

	@@all_probs = [Chapter1, Chapter2, Chapter3, Chapter6, Chapter7].map { |chap| chap::PROBLEMS }.flatten

	def get_probs
		return [] if session[:problems].nil?
		session[:problems].map { |p| dec_prob(p) }
	end

	def set_probs(*probs)
		myprobs = (probs[0].is_a? Array) ? probs[0] : probs
		session[:problems] = myprobs.map { |p| enc_prob(p) }
	end

	private

	def all_probs
		@@all_probs
	end

	# TODO make a global hash instead of using Marshal for every request...
	def enc_prob(p)
		#TODO SEE ABOVE!
		Marshal.dump(p)
	end

	def dec_prob(p)
		Marshal.load(p)
	end
end
