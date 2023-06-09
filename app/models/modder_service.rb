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
    'full-builds': { name: 'full builds', color: '#6d6b6b', solid: true },
    'prebuilt-controllers': { name: 'prebuilt controllers', color: '#6d6b6b', solid: true },
    'diagnostics-repairs': { name: 'diagnostics/repairs', color: '#6d6b6b', solid: true },
    'accepting-send-ins': { name: 'accepting send-ins', color: '#6d6b6b', solid: true },
    'commissions-open': { name: 'commissions open', color: '#fdb03a', color_dark: '#444f9a', solid: true },

    # functional/electrical
    'phobs': { name: 'phobs', color: '#444f9a', color_dark: '#5a69cc' },
    'snapback-modules': { name: 'snapback modules', color: '#444f9a', color_dark: '#5a69cc' },
    'electrical-mods': { name: 'electrical mods', color: '#444f9a', color_dark: '#5a69cc' },
    'notching': { name: 'notching', color: '#444f9a', color_dark: '#5a69cc' },

    # resin
    'resin-buttons': { name: 'resin buttons', color: '#fdb03a' },
    'resin-sticks': { name: 'resin sticks', color: '#fdb03a' },
    'rubber-capped-sticks': { name: 'rubber-capped sticks', color: '#fdb03a' },
    'full-resin-sticks': { name: 'full resin sticks', color: '#fdb03a' },
    'resin-triggers': { name: 'resin triggers', color: '#fdb03a' },
    'resin-shells': { name: 'resin shells', color: '#fdb03a' },

    # shell art
    'shell-painting': { name: 'shell painting', color: '#0d8b98' },
    'shell-tinting': { name: 'shell tinting', color: '#0d8b98' },
    'shell-dyeing': { name: 'shell dyeing', color: '#0d8b98' },

    # other aesthetics
    'paracords': { name: 'paracords', color: '#c12022' },

    # other
    'parts': { name: 'replacement parts', color: '#211f21', color_dark: '#b8bfbf' },
    'tools': { name: 'modding tools', color: '#211f21', color_dark: '#b8bfbf' },
    'procon': { name: 'procons', color: '#211f21', color_dark: '#b8bfbf' },
    'rectangle-controllers': { name: 'rectangle controllers', color: '#211f21', color_dark: '#b8bfbf' }

  }.freeze

  belongs_to :modder

  def self.enabled_services
    ALL_SERVICES.reject { |slug, service| service[:disabled] }
  end

end
