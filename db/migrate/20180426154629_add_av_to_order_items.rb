class AddAvToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :av, :string
  end
end
