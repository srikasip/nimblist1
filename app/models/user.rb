class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates_uniqueness_of :name

  has_many :tasks


  def tasks
    tasks = Task.find_all_by_user_id(self.id)
  end

end
