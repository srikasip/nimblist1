class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integder :task_id
      t.string :name

      t.timestamps
    end
  end
end
