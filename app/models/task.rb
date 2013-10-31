class Task < ActiveRecord::Base
  belongs_to :user
  has_many :task_tags
  has_many :tags, :through => :task_tags


  def tags
    tasktags = TaskTags.find_all_by_task_id(self.id)
    tags = Array.new
    tasktags.each do |tasktag|
      tags.push Tags.find(tasktag.tag_id)
    end

    return tags
  end

  def create_task(user, item, tags)
    self.user_id = user.id
    self.item = item
    self.is_complete = false
    self.save

    tags.each do |tag|
      Tags.check_create(tag, self.id)
    end

  end

end
