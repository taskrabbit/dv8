class AddUserJoins < ActiveRecord::Migration
  def up
    create_table :users_friends, :id => false do |t|
      t.integer :user_id
      t.integer :friend_id
    end
  end

  def down
    drop_table :user_friends
  end
end
