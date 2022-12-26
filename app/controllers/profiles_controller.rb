class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def show
    return redirect_to edit_profile_path if current_modder.blank?
    redirect_to modder_path(current_modder)
  end

  def edit
    @modder = current_modder || Modder.new(user: current_user)
    @onboarding = !@modder.persisted?
  end

  def create
    update
  end

  def update
    @modder = current_modder || Modder.new(user: current_user)
    @onboarding = !@modder.persisted?

    begin
      @modder.transaction do
        @modder.update!(params.require(:modder).permit(:name, :bio, :city, :latitude, :longitude))

        @modder.modder_services.destroy_all

        services = JSON.parse params[:modder][:services]
        services.each_with_index do |service, index|
          next unless ModderService::ALL_SERVICES[service.to_sym].present?

          @modder.modder_services.create!({
            index:,
            service:
          })
        end
      end

      flash[:notice] = 'Your profile was updated.'
      redirect_to user_root_path
    rescue StandardError
      flash[:error] = "There was a problem saving your profile. #{@modder.errors.full_messages.join('. ')}"
      render :edit
    end
  end

end
