class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :giver_id
      t.integer :receivingpost_id
      t.integer :receivingcomment_id 
      t.timestamps null: false
    end
    add_index :transactions, :giver_id
    add_index :transactions, :receivingpost_id
    add_index :transactions, :receivingcomment_id
    add_index :transactions, [:giver_id, :receivingpost_id], unique: true
    add_index :transactions, [:giver_id, :receivingcomment_id], unique: true
  end
end
