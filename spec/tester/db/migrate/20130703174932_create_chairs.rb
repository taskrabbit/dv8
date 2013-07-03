class CreateChairs < ActiveRecord::Migration
  def change
    create_table :chairs do |t|
      t.string :name
      t.timestamps
    end

    add_column :users, :chair_id, :integer
  end
end
