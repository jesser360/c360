class AddBuyerEmailToUserOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :user_orders, :buyer_email, :string
  end
end
