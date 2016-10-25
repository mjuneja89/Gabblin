class AddSpentCoinsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spent_coins, :integer, :default => 0
  end
end
