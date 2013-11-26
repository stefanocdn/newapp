class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.string :subject
      t.string :body
      t.boolean :sent

      t.timestamps
    end
    add_index :messages, [:user_id, :created_at]
  end
end
