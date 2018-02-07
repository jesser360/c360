class AddCurrentAmountToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :current_amount, :integer
  end
end
