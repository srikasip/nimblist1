class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates_uniqueness_of :name

  has_many :tasks


  def tasks
    tasks = Task.find_all_by_user_id(self.id)
  end

  def tags
    if self.tasks do |task|
      tags.
    else
      tags = nil
    end
  end

end
