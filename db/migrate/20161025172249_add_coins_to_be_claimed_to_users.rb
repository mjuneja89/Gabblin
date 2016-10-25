class AddCoinsToBeClaimedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coinstobeclaimed, :integer, :default => 0
  end
end
