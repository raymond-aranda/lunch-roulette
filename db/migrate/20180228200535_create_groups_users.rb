class CreateGroupsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :groups_users do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.string :sender
      t.boolean :notice, default: true
      t.boolean :accepted, default: false
      t.timestamps
    end
  end
end
