class AddSchemaVersion < ActiveRecord::Migration
  def change
    add_column :feedbacks, :schema_version, :float
  end
end
