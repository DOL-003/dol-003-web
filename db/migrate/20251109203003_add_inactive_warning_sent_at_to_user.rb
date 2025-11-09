class AddInactiveWarningSentAtToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :inactive_warning_sent_at, :datetime
  end
end
