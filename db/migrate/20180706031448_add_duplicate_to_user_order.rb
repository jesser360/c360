class AddDuplicateToUserOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :duplicate, :boolean
  end
end
