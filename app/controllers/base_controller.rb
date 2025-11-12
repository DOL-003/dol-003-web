class BaseController < ActionController::Base

  before_action :set_logger_metadata
  around_action :record_action_metrics

  private

  def record_action_metrics
    if request.path.present?
      path_segments = request.path.split('/').filter(&:present?)
      path_segments = ['root'] if path_segments.empty?
      StatsD.increment("request_path.#{request.subdomain || 'www'}.#{path_segments.join('_')}")
    end
    StatsD.increment("request.#{controller_name}.#{action_name}")
    StatsD.measure("request.#{controller_name}.#{action_name}") do
      yield
    end
  end

  def set_logger_metadata
    Rails.logger.formatter.set_entrypoint("#{controller_name}##{action_name}")
  end

end
