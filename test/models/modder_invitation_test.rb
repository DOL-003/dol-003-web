# == Schema Information
#
# Table name: modder_invitations
#
#  id          :bigint           not null, primary key
#  claim_token :string
#  status      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  modder_id   :bigint
#
# Indexes
#
#  index_modder_invitations_on_claim_token  (claim_token)
#  index_modder_invitations_on_modder_id    (modder_id)
#
require "test_helper"

class ModderInvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
