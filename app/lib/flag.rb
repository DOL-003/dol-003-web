class Flag

  FLAGS = {

    knowledge_base: [1, 2, 3, 4, 5, 6]

  }.freeze

  def self.enabled?(flag, params = {})
    return false unless FLAGS[flag].present?

    # Random bucketing
    if FLAGS[flag].is_a? Numeric
      return false unless params[:session_id].present?

      return params[:session_id].sum % 100 < FLAGS[flag]
    end

    # User list
    if FLAGS[flag].is_a? Array
      return false unless params[:user].present?

      return params[:user].id.in? FLAGS[flag]
    end

    # Advanced settings
    if FLAGS[flag].is_a? Hash
      # TODO
    end

    false
  end

end
