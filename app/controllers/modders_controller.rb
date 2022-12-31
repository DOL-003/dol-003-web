class ModdersController < ApplicationController

  def index
    services = params[:services] || []
    @services = JSON.parse(services).select { |service| ModderService::ALL_SERVICES.include? service.to_sym }
    @city = params[:city]
    @latitude = params[:latitude]
    @longitude = params[:longitude]

    @results = true
  end

  def show
    @modder = Modder.find_by(slug: params[:id]) or not_found
  end

end
