class RemoveOrderItemFromUserOrder < ActiveRecord::Migration[5.1]
  def change
    remove_reference :user_orders, :order_item, foreign_key: true
  end
end
