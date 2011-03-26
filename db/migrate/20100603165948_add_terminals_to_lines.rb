class AddTerminalsToLines < ActiveRecord::Migration
  def self.up
    add_column :lines, :terminal_a, :string
    add_column :lines, :terminal_b, :string
  end

  def self.down
    remove_column :lines, :terminal_b
    remove_column :lines, :terminal_a
  end
end
