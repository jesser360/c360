class AddOrderItemToUserOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_orders, :order_item, foreign_key: true
  end
end
