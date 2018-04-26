class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.string :name
      t.integer :price
      t.integer :max_amount
      t.integer :bulk_order_amount
      t.integer :current_amount

      t.timestamps
    end
  end
end
