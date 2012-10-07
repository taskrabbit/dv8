class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.integer :parent_id
      t.integer :best_friend_id
      t.string  :owner_type
      t.integer :owner_id
      t.timestamps
    end
  end
end
