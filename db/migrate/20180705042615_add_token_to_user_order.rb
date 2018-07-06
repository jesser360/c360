class AddTokenToUserOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :token, :string
    add_index :user_orders, :token, unique: true
  end
end
