class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :stops, :route_id
    add_index :stops, :location_id
    add_index :locations, :emt_code
    add_index :locations, :lat
    add_index :locations, :lng
  end

  def self.down
    remove_index :locations, :lng
    remove_index :locations, :lat
    mind
    remove_index :locations, :emt
    remove_index :stops, :location_id
    mind
    remove_index :stops, :route_id
    mind
  end
end
