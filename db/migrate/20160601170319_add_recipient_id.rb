class AddRecipientId < ActiveRecord::Migration
  def change
    add_column :feedbacks, :recipient_id, :string
  end
end
