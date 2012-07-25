require 'grade6'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper

  @@all_chapters = CHAPTERS

  private

  # TODO make a global hash instead of using Marshal for every request...
  def enc_prob(p)
    #TODO SEE ABOVE!
    Marshal.dump(p)
  end

  def dec_prob(p)
    Marshal.load(p)
  end

  def authenticate
    deny_access unless signed_in?
  end
end
