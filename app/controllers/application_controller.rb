class ApplicationController < ActionController::Base

  layout 'default'

  def index
    @user_id = current_user&.id
    @featured_modders = Modder.featured_modders
  end

  def ping
    head :no_content
  end

  def about
    @title = 'About'
  end

  def terms
    @title = 'Terms of Service'
  end

  def rules
    @title = 'House Rules'
  end

  def privacy_policy
    @title = 'Priacy Policy'
  end

  protected

  def current_modder
    return nil if !user_signed_in?

    Modder.find_by(user: current_user)
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def flag_enabled?(flag)
    Flag.enabled?(flag, user: current_user, session_id: session.id)
  end

  def redirect_if_signed_in(path = nil)
    redirect_to (path || root_path) if user_signed_in?
  end

end
