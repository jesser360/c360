class AddExpirationToUserOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :expiration, :integer
  end
end
