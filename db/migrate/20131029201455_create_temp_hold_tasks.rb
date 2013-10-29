class CreateTempHoldTasks < ActiveRecord::Migration
  def change
    create_table :temp_hold_tasks do |t|
      t.string :sender
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
