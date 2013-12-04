class AddGeocdingToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :adress, :string
    add_column :lessons, :latitude, :float
    add_column :lessons, :longitude, :float
  end
end
