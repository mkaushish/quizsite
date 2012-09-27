require_relative '../questionbase'
require_relative '../tohtml'
require_relative '../modules/names'
require_relative '../modules/units'
require_relative '../modules/items'
require_relative 'c12.rb'

include ToHTML

module MyChapter12
  include Chapter12
end
