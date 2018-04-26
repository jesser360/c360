class RemoveItemFromUserOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_orders, :item, :string
  end
end
