# == Schema Information
#
# Table name: user_invitations
#
#  id          :bigint           not null, primary key
#  claim_token :string
#  status      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_user_invitations_on_claim_token  (claim_token)
#  index_user_invitations_on_user_id      (user_id)
#
class UserInvitation < ApplicationRecord

  include Rails.application.routes.url_helpers

  STATUS_UNCLAIMED = 'unclaimed'.freeze
  STATUS_CLAIMED = 'claimed'.freeze

  belongs_to :user, optional: true

  validates :status, inclusion: { in: [STATUS_UNCLAIMED, STATUS_CLAIMED] }

  before_validation on: :create do |user_invitation|
    user_invitation.claim_token ||= SecureRandom.urlsafe_base64(20)
    user_invitation.status ||= STATUS_UNCLAIMED
  end

  def registration_url
    new_user_registration_url(invitation_token: claim_token, host: 'https://dol-003.info')
  end

end
