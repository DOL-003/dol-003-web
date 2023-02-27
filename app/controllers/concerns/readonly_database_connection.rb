module ReadonlyDatabaseConnection
  extend ActiveSupport::Concern

  included do
    if ENV['DB_CONFIG'].present?
      rescue_from ActiveRecord::StatementInvalid do |error|
        raise error unless error.message.match?(/PG::InsufficientPrivilege/i)
      end
    end
  end
end
