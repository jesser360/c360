class AddTotalPriceToUserOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :total_price, :integer
  end
end
