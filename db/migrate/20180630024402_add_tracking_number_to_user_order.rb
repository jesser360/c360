class AddTrackingNumberToUserOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :tracking_number, :string
    add_column :user_orders, :tracking_label, :string
  end
end
