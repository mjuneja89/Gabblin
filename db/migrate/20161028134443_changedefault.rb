class Changedefault < ActiveRecord::Migration
  def change
  	change_column :users, :total_spent_coins, :integer, :default => 0
  end
end
