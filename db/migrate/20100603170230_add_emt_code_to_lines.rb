class AddEmtCodeToLines < ActiveRecord::Migration
  def self.up
    add_column :lines, :emt_code, :integer
  end

  def self.down
    remove_column :lines, :emt_code
  end
end
