class Changedefaultusers < ActiveRecord::Migration
  def change
  	change_column_default :users, :coin_count, 15
  end
end
