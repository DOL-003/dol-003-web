class CreateEventLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :event_logs do |t|
      t.string :event_name
      t.json :data

      t.timestamps
    end
  end
end
