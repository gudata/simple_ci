class AddFieldsToCommiters < ActiveRecord::Migration
  def self.up
    add_column :developers, :sash_id, :integer
    add_column :developers, :level, :integer, :default => 0
  end

  def self.down
    remove_column :developers, :sash_id
    remove_column :developers, :level
  end
end
