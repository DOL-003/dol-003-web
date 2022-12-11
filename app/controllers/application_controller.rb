class ApplicationController < ActionController::Base

  layout 'default'

  def index
    @user_id = current_user_id
  end

  def ping
    head :no_content
  end

  def about
  end

  protected

  def current_user_id
    return @current_user_id if @current_user_id.present?

    passage_client = Passage::Client.new(app_id: Rails.application.credentials.passage[:app_id], api_key: Rails.application.credentials.passage[:api_key])
    begin
      @current_user_id = passage_client.auth.authenticate_request(request)
    rescue Passage::PassageError => e
      nil
    end
  end

end
