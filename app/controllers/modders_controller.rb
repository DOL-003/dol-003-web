class ModdersController < ApplicationController

  before_action :authenticate_user!, only: [:onboarding, :profile]

  def onboarding
    return redirect_to user_root_path if Modder.find_by(user: current_user).present?
    @modder = Modder.new
  end

  def profile
    @modder = Modder.find_by(user: current_user)
    return redirect_to onboarding_path if @modder.blank?

    @id = current_user.id
  end

end
