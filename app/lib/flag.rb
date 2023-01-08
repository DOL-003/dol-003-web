class Flag

  @@flags = nil

  def self.enabled?(flag, params = {})

    return false unless flags[flag].present?

    # Boolean on/off
    if flags[flag].in? [true, false]
      return flags[flag]
    end

    # Random session-based bucketing
    if flags[flag].is_a? Numeric
      return false unless params[:session_id].present?

      return params[:session_id].to_s.sum % 100 < flags[flag]
    end

    # User list
    if flags[flag].is_a? Array
      return false unless params[:user].present?

      return params[:user].id.in? flags[flag]
    end

    # Advanced settings
    if flags[flag].is_a? Hash

      if flags[flag][:users].present?
        if params[:user].present? && params[:user].in?(flags[flag][:users])
          return true
        end
      end

      if flags[flag][:percentage].present?
        if params[:session_id].present? && (params[:session_id].to_s.sum % 100) < flags[flag][:percentage]
          return true
        end
      end

    end

    false
  end

  private

  def self.flags
    return @@flags if @@flags.present?

    @@flags = YAML.load(File.read("./app/lib/flags/#{Rails.env}.yml")).deep_symbolize_keys.freeze
  end

end
