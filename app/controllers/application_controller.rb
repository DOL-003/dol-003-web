class ApplicationController < BaseController

  include ReadonlyDatabaseConnection

  layout 'default'

  before_action :set_recent_slugs
  before_action :update_user_activity

  def index
    @user_id = current_user&.id
    @featured_modders = Modder.featured_modders
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

  def update_user_activity
    return unless user_signed_in?

    if current_modder && current_user.inactive_warning_sent_at.present?
      if current_modder.active?
        current_user.inactive_warning_sent_at = nil
        current_user.save

        EventLog.log 'inactive_warning_cleared', user_id: current_user.id, modder_slug: current_modder.slug
        flash[:notice] = "You will no longer be marked inactive. While you're here, check your profile to make sure your services and links are up to date."
      elsif current_modder.inactive? && current_user.inactive_warning_sent_at > current_user.last_active_at
        EventLog.log 'inactive_flash_displayed', user_id: current_user.id, modder_slug: current_modder.slug
        flash[:error] = 'You have been marked inactive. Edit your profile to set your status back to active.'
      end
    end

    current_user.touch :last_active_at
  end

end
