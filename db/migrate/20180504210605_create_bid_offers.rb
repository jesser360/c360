class CreateBidOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :bid_offers do |t|
      t.references :user, foreign_key: true
      t.references :bid, foreign_key: true
      t.date :delivery_date
      t.integer :price
      t.string :notes

      t.timestamps
    end
  end
end
