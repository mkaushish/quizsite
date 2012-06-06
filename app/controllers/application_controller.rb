require 'grade6'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper

  @@all_chapters = [CricketQuestions, Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7, Chapter8, Chapter9, Geo, Physics]
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
