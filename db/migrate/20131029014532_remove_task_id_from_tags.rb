class RemoveTaskIdFromTags < ActiveRecord::Migration
  def change
    remove_column :tags, :task_id, :integer
  end
end
