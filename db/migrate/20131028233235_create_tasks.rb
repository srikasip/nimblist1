class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :item
      t.boolean :is_complete
      t.datetime :deadline
      t.string :location

      t.timestamps
    end
  end
end
