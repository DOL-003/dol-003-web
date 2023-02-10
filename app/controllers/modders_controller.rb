class ModdersController < ApplicationController

  def index
    @title = 'Modder search'

    @services = []
    if params[:services].present?
      if params[:services].is_a? Array
        @services = params[:services]
      elsif params[:services].is_a? String
        @services = params[:services].split(',')
      end
    elsif params[:service].present?
      @services = [params[:service]]
    end

    @services = @services.select { |service| ModderService::ALL_SERVICES.include? service.to_sym }

    @city = params[:city]
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    @query = params[:query]
    @map = params[:map] == '1' || (@latitude.present? && @longitude.present?)
    @services_visible = cookies[:services_visible] != '0'

    @results = Modder.active

    if @services.present?
      eligible_modders = ModderService.where(service: @services).group(:modder_id).having('count(modder_id) = ?', @services.count).count.keys
      @results = @results.includes(:modder_services).where(id: eligible_modders)
    end

    if @query.present?
      @results = @results.name_similar_to(@query)
    elsif @latitude.present? && @longitude.present?
      @results = @results.order_by_proximity(@latitude, @longitude)
    else
      @results = @results.order('random()')
    end
  end

  def show
    @modder = Modder.find_by(slug: params[:id]) or not_found
    return not_found if @modder.inactive? && @modder != current_modder
    @title = @modder.name
    @description = "#{@modder.name}’s profile on DOL-003.info, a directory of GameCube controller modders."
  end

end
