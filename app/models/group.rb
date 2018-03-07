class Group < ApplicationRecord
  has_many :groups_users
  has_many :users, through: :groups_users
  has_many :lunch_picks, through: :users
  validates :name, presence: true
end
