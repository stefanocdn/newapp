class CreateScholarships < ActiveRecord::Migration
  def change
    create_table :scholarships do |t|
      t.integer :user_id
      t.integer :school_id
      t.date :start_date
      t.date :end_date
      t.string :degree
      t.string :field

      t.timestamps
    end
    add_index :scholarships, :user_id
    add_index :scholarships, :school_id
    add_index :scholarships, [:user_id, :school_id], unique: true
  end
end
