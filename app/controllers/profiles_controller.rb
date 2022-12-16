class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def show
    return redirect_to edit_profile_path if current_modder.blank?
    return redirect_to modder_path(current_modder)
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

    if @modder.update(params.require(:modder).permit(:name, :bio))
      return redirect_to user_root_path
    else
      flash[:error] = "There was a problem saving your profile. #{@modder.errors.full_messages.join('. ')}"
      render :edit
    end
  end

end
