# == Schema Information
#
# Table name: problemanswers
#
#  id         :integer         not null, primary key
#  correct    :boolean
#  problem_id :integer
#  created_at :datetime
#  updated_at :datetime
#  response   :string(255)
#

require 'spec_helper'

describe Problemanswer do
  pending "add some examples to (or delete) #{__FILE__}"
end
