class ChangeUserRefToInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :messages, :user_id, :integer
  end
end
