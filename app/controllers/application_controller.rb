class ApplicationController < ActionController::Base

  include ReadonlyDatabaseConnection

  layout 'default'

  before_action :set_recent_slugs
  before_action :touch_last_active_at

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

  def vetting
    @title = 'Modder vetting'
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
    return nil unless user_signed_in?

    Modder.find_by(user: current_user)
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def authenticate_admin!
    redirect_to root_path unless current_user.admin?
  end

  def flag_enabled?(flag)
    Flag.enabled?(flag, user: current_user, session_id: session.id)
  end

  def redirect_if_signed_in(path = nil)
    redirect_to (path || root_path) if user_signed_in?
  end

  def add_recent_slug(slug)
    recent_slugs = cookies[:recent_slugs]
    recent_slugs = recent_slugs.present? ? JSON.parse(recent_slugs) : []
    recent_slugs = [slug] + recent_slugs

    cookies[:recent_slugs] = { 
      value: JSON.generate(recent_slugs.uniq[0..9]),
      expires: 30.days,
      domain: :all
    }
  rescue StandardError
    # oh well
  end

  def set_recent_slugs
    @recent_slugs = cookies[:recent_slugs].present? ? JSON.parse(cookies[:recent_slugs]) : nil
  end

  def touch_last_active_at
    return unless user_signed_in?

    current_user.touch :last_active_at
  end

end
