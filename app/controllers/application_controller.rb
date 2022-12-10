class ApplicationController < ActionController::Base

  layout 'default'

  def index
  end

  def ping
    head :no_content
  end

  def about
  end

end
