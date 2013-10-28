class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :reviewer_id
      t.integer :reviewed_id
      t.text :content

      t.timestamps
    end
    add_index :reviews, :reviewer_id
    add_index :reviews, :reviewed_id
    add_index :reviews, [:reviewer_id, :created_at]
    add_index :reviews, [:reviewed_id, :created_at]
  end
end
