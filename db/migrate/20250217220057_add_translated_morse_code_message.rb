class AddTranslatedMorseCodeMessage < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :translated_message, :string
  end
end
