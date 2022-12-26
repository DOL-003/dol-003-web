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

    # meta
    'prebuilt-controllers': { name: 'prebuilt controllers', color: '#222' },
    'accepting-send-ins': { name: 'accepting send-ins', color: '#222' },
    'commissions-open': { name: 'commissions open', color: '#222' },
    'diagnostics-repairs': { name: 'diagnostics/repairs', color: '#222' },

    # functional/electrical
    'phobs': { name: 'phobs', color: '#444f9a' },
    'snapback-modules': { name: 'snapback modules', color: '#444f9a' },
    'electrical-mods': { name: 'electrical mods', color: '#444f9a' },
    'notching': { name: 'notching', color: '#444f9a' },

    # resin
    'resin-buttons': { name: 'resin buttons', color: '#fdb03a' },
    'resin-sticks': { name: 'resin sticks', color: '#fdb03a' },
    'resin-triggers': { name: 'resin triggers', color: '#fdb03a' },
    'resin-shells': { name: 'resin shells', color: '#fdb03a' },

    # shell art
    'shell-painting': { name: 'shell painting', color: '#0d8b98' },
    'shell-tinting': { name: 'shell tinting', color: '#0d8b98' },
    'shell-dyeing': { name: 'shell dyeing', color: '#0d8b98' },

    # other aesthetics
    'paracords': { name: 'paracords', color: '#c12022' },

  }.freeze

  belongs_to :modder

  def self.enabled_services
    ALL_SERVICES.reject { |slug, service| service[:disabled] }
  end

end
