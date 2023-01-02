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
class ModderInvitation < ApplicationRecord

  STATUS_UNCLAIMED = 'unclaimed'.freeze
  STATUS_CLAIMED = 'claimed'.freeze

  belongs_to :modder

  validates :status, inclusion: { in: [STATUS_UNCLAIMED, STATUS_CLAIMED] }

end
