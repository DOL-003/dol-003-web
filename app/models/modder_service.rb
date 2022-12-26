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

  ALL_SERVICES = {
    'prebuilt-controllers': { name: 'prebuilt controllers', color: '#fdb03a' },
    'diagnostics-repairs': { name: 'diagnostics/repairs', color: '#fdb03a' },
    'phobs': { name: 'phobs', color: '#fdb03a' },
    'snapback-modules': { name: 'snapback modules', color: '#fdb03a' },
    'accepting-send-ins': { name: 'accepting send-ins', color: '#fdb03a' },
    'commissions-open': { name: 'commissions open', color: '#fdb03a' },
    'resin-buttons': { name: 'resin buttons', color: '#fdb03a' },
    'resin-sticks': { name: 'resin sticks', color: '#fdb03a' },
    'resin-triggers': { name: 'resin triggers', color: '#fdb03a' },
    'resin-shells': { name: 'resin shells', color: '#fdb03a' },
    'shell-painting': { name: 'shell painting', color: '#fdb03a' },
    'shell-tinting': { name: 'shell tinting', color: '#fdb03a' },
    'shell-dyeing': { name: 'shell dyeing', color: '#fdb03a' },
    'electrical-mods': { name: 'electrical mods', color: '#fdb03a' },
    'paracords': { name: 'paracords', color: '#fdb03a' },
    'notching': { name: 'notching', color: '#fdb03a' }
  }.freeze

  belongs_to :modder

  def self.enabled_services
    ALL_SERVICES.reject { |slug, service| service[:disabled] }
  end

end
