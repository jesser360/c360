class RemoveSFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :s, :string
  end
end
