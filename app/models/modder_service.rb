# == Schema Information
#
# Table name: modder_services
#
#  id         :bigint           not null, primary key
#  index      :integer          not null
#  service    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  modder_id  :bigint           not null
#
# Indexes
#
#  index_modder_services_on_modder_id  (modder_id)
#
class ModderService < ApplicationRecord

  SERVICES = [
    { name: 'prebuilt controllers', color: '#fdb03a' },
    { name: 'repairs', color: '#fdb03a' }
  ]

  belongs_to :modder

end
