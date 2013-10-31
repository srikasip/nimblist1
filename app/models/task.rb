class Task < ActiveRecord::Base
  belongs_to :user
  has_many :task_tags
  has_many :tags, :through => :task_tags


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
