class ModdersController < ApplicationController

  def auth
    modder = Modder.find_by(user_id: current_user_id)
    return redirect_to onboarding_path if modder.blank?

    redirect_to profile_path
  end

  def onboarding
  end

  def profile
    @id = current_user_id
  end

end
