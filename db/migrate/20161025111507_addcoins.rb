class Addcoins < ActiveRecord::Migration
  def change
  	add_column :users, :coin_count, :integer, :default => 30
  	add_column :posts, :coin_count, :integer, :default => 0
  	add_column :comments, :coin_count, :integer, :default => 0
  end
end
