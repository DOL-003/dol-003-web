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
class EventLog < ApplicationRecord
  def self.log(event_name, data)
    self.create!(event_name:, data:)
  end
end
