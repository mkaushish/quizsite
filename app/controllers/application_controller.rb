require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'
require 'c8'
require 'geo'
# require 'c10'
# require 'c12'
require 'crqu'


class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper

  @@all_chapters = [CricketQuestions, Chapter1, Chapter2, Chapter3, Chapter6, Chapter7, Chapter8, Geo]
  def get_probs
    return [] if session[:problems].nil?
    session[:problems].map { |p| dec_prob(p) }
  end

  def set_probs(*probs)
    myprobs = (probs[0].is_a? Array) ? probs[0] : probs
    session[:problems] = myprobs.map { |p| enc_prob(p) }
  end

  def set_quiz(quiz)
    session[:quizid] = quiz.id
    set_probs(quiz.ptypes)
  end

  def get_next_ptype
    plist = get_probs
    plist = all_probs if plist.empty?
    ptype = plist.sample
  end


  private

  # TODO make a global hash instead of using Marshal for every request...
  def enc_prob(p)
    #TODO SEE ABOVE!
    Marshal.dump(p)
  end

  def dec_prob(p)
    Marshal.load(p)
  end
end
