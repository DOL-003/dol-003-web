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

end
