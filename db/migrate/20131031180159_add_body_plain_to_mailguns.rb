class AddBodyPlainToMailguns < ActiveRecord::Migration
  def change
    add_column :mailguns, :body_plain, :text
  end
end
