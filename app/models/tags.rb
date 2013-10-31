class Tags < ActiveRecord::Base
  has_many :task_tags
  has_many :tasks, :through => :task_tags

  def task_id
    task_id = TaskTags.find_by_tag_id(self.id)
  end

  def self.check_create(tag, task_id)
    tag_item = Tags.find_by_name(tag)
    if tag_item
      TaskTags.create(:task_id=>task_id, :tag_id=>tag_item.id)
    else
      tag_item = Tags.create(:name=>tag)
      TaskTags.create(:task_id=>task_id, :tag_id=>tag_item.id)
    end
  end
end
