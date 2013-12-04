class FixColumnNameToLessons < ActiveRecord::Migration
  def change
    rename_column :lessons, :adress, :address
  end
end
