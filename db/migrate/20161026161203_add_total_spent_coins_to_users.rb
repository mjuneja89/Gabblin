class AddTotalSpentCoinsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_spent_coins, :integer, :default => 5
  end
end
