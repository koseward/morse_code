class AddResponseToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :response, :string
  end
end
