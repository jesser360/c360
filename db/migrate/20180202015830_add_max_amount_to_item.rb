class AddMaxAmountToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :s, :string
    add_column :items, :max_amount, :integer
  end
end
