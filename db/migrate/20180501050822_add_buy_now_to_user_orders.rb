class AddBuyNowToUserOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :buy_now, :boolean
  end
end