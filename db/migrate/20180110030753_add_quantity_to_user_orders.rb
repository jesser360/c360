class AddQuantityToUserOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :quantity, :integer
  end
end
