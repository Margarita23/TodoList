class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :title
      t.integer :user_id
      t.string :status
      t.date :deadline

      t.timestamps
    end
  end
end
