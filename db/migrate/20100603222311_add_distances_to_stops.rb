class AddDistancesToStops < ActiveRecord::Migration
  def self.up
    add_column :stops, :total_distance, :integer
    add_column :stops, :prev_distance, :integer
  end

  def self.down
    remove_column :stops, :prev_distance
    remove_column :stops, :total_distance
  end
end
