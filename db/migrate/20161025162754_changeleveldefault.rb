class Changeleveldefault < ActiveRecord::Migration
  def change
  	change_column_default :users, :level, "Level 1"
  end
end
