# == Schema Information
#
# Table name: event_logs
#
#  id         :bigint           not null, primary key
#  data       :json
#  event_name :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class EventLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
