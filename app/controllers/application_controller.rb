class ApplicationController < ActionController::Base
  def index
  end

  def ping
    head :no_content
  end
end
