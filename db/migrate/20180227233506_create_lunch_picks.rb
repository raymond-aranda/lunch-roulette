class CreateLunchPicks < ActiveRecord::Migration[5.1]
  def change
    create_table :lunch_picks do |t|
      t.belongs_to :user
      t.string :restaurant
      t.string :description
      t.timestamps
    end
  end
end
