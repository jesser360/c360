class AddChargeTokenToUserOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :charge_token, :string
  end
end
