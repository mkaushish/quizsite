require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'

module ApplicationHelper
  def adderror(string)
    if flash[:errors].nil?
      flash[:errors] = [ string ]
    else
      flash[:errors] << string
    end
  end

  def geterrors
    flash[:errors] ||= []
    flash[:errors]
  end
end
