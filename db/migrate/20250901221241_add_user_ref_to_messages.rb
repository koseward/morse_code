class AddUserRefToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :user_id, :number
    add_index :messages, :user_id
    add_foreign_key :messages, :users
  end
end
