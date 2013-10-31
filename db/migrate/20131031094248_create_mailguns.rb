class CreateMailguns < ActiveRecord::Migration
  def change
    create_table :mailguns do |t|
      t.string :sender
      t.string :recipient
      t.string :subject
      t.text :stripped_text

      t.timestamps
    end
  end
end
