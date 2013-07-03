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

  def authenticate_admin
    deny_access unless current_user.email == "m.adhavkaushish@gmail.com" or current_user.email == "t.homasramfjord@gmail.com
"  or current_user.email == "madhav.kaushish@gmail.com"  or current_user.email == "amandeep.bhamra@gmail.com"
  end

  def form_err_js(id, message)
    "$('##{id}').addClass('invalid');$('##{id}_err').text(\"#{message}\");"
  end

  # pref : the prefix for the form - if obj has a name field, it will have id pref_name
  # obj : the invalid model object you just failed to save/create
  def form_for_errs(pref, obj)
    obj.errors.to_hash.to_a.map do |name_err|
      form_err_js "#{pref}_#{name_err[0]}", name_err[1][0]
    end.join
  end
end
