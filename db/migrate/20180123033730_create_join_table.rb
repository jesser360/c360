class CreateJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :bulk_orders do |t|
      t.index [:user_id, :bulk_order_id]
      t.index [:bulk_order_id, :user_id]
    end
  end
end
