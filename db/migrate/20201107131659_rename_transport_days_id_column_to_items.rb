class RenameTransportDaysIdColumnToItems < ActiveRecord::Migration[6.0]
  def change
    rename_column :items, :transport_days_id, :transportday_id
  end
end
