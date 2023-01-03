# == Schema Information
#
# Table name: modder_photos
#
#  id         :bigint           not null, primary key
#  height     :integer
#  index      :integer          not null
#  photo      :string           not null
#  uuid       :string           not null
#  width      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  modder_id  :bigint           not null
#
# Indexes
#
#  index_modder_photos_on_modder_id  (modder_id)
#
require "test_helper"

class ModderPhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
