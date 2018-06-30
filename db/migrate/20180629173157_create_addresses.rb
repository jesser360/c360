class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.boolean :shipping
      t.string :street
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :name
      t.string :apt
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
