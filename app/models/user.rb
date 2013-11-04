class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates_uniqueness_of :name

  has_many :tasks


  def tasks(active_tag_id)
    if active_tag_id != 0
      all_tasks = Task.select(:task_id).where('user_id=?', self.id)
      taskTags = TaskTags.select(:task_id).where(:tag_id=>active_tag_id, :task_id=>all_tasks).distinct
      tasks = Task.where(id: taskTags)
    else
      tasks = Task.find_all_by_user_id(self.id)
    end
  end

  def tags
    my_task_ids = Task.select(:id).where("user_id = ?", self.id)
    my_tag_ids = TaskTags.select(:tag_id).where(task_id: my_task_ids)
    tags = Tags.where(id: my_tag_ids).distinct
    return tags
  end


end