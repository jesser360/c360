class RemoveUserFromAddress < ActiveRecord::Migration[5.1]
  def change
    remove_reference :addresses, :user, foreign_key: true
  end
end
