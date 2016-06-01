class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string  :recipient, null: false
      t.string  :sender, null: false
      t.string  :sender_id, null: false
      t.string  :team_domain, null: false
      t.string  :team_id, null: false
      t.string  :channel_name, null: false
      t.string  :channel_id, null: false
      t.string  :response_url, null: false
      t.string  :text, null: false
      t.integer :quantity, null: false
      t.string  :badge, null: false
      t.string  :reason, null: false

      t.timestamps null: false
    end
  end
end
