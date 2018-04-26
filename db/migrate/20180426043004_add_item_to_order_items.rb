class AddItemToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_items, :item, foreign_key: true
  end
end
