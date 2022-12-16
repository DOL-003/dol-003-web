class ApplicationController < ActionController::Base

  layout 'default'

  def index
    @user_id = current_user&.id
  end

  def ping
    head :no_content
  end

  def about
  end

  protected

  def current_modder
    return nil if !user_signed_in?

    Modder.find_by(user: current_user)
  end

end
