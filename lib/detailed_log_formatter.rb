class DetailedLogFormatter < Logger::Formatter
  @entrypoint = nil
  @uuid = nil

  def set_entrypoint(entrypoint)
    Thread.current[:entrypoint] = entrypoint
    Thread.current[:uuid] = SecureRandom.uuid_v4
  end

  def call(severity, time, progname, msg)
    "[#{severity.upcase}] [#{time.strftime("%Y-%m-%d %H:%M:%S.%L")}]#{progname.present? ? " [#{progname}]" : ''}#{Thread.current[:entrypoint].present? ? " [#{Thread.current[:entrypoint]}]" : ''}#{Thread.current[:uuid].present? ? " [#{Thread.current[:uuid]}]" : ''} #{String === msg ? msg : msg.inspect}\n"
  end
end
