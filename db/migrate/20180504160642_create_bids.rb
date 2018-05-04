class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.integer :amount
      t.string :title
      t.integer :price_min
      t.integer :price_max
      t.belongs_to :supplier, :class_name => 'User'
      t.belongs_to :buyer, :class_name => 'User'
      t.timestamps
    end
  end
end
