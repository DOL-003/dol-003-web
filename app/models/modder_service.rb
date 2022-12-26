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

  ALL_SERVICES = [
    { name: 'prebuilt controllers', color: '#fdb03a' },
    { name: 'diagnostics/repairs', color: '#fdb03a' },
    { name: 'phobs', color: '#fdb03a' },
    { name: 'snapback modules', color: '#fdb03a' },
    { name: 'accepting send-ins', color: '#fdb03a' },
    { name: 'commissions open', color: '#fdb03a' },
    { name: 'resin buttons', color: '#fdb03a' },
    { name: 'resin sticks', color: '#fdb03a' },
    { name: 'resin triggers', color: '#fdb03a' },
    { name: 'resin shells', color: '#fdb03a' },
    { name: 'shell painting', color: '#fdb03a' },
    { name: 'shell tinting', color: '#fdb03a' },
    { name: 'shell dyeing', color: '#fdb03a' },
    { name: 'electrical mods', color: '#fdb03a' },
    { name: 'paracords', color: '#fdb03a' },
    { name: 'notching', color: '#fdb03a' }
  ].freeze

  belongs_to :modder

  def self.enabled_services
    ALL_SERVICES.reject { |service| service[:disabled] }
  end

  def self.get_service_by_slug(service_slug)
    ALL_SERVICES.each do |service|
      return service if service[:name].parameterize == service_slug
    end
  end

end