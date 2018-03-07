class CreateLunchPicks < ActiveRecord::Migration[5.1]
  def change
    create_table :lunch_picks do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.string :restaurant
      t.timestamps
    end
  end
end
