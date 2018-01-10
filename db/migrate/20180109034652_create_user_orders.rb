class CreateUserOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :user_orders do |t|
      t.string :item
      t.references :user, foreign_key: true
      t.references :bulk_order, foreign_key: true

      t.timestamps
    end
  end
end
