class AddUserOrderToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_reference :addresses, :user_order, foreign_key: true
  end
end
