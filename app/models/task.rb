class Task < ApplicationRecord
  belongs_to :category
  has_many :task_assignees
  has_many :users, through: :task_assignees

  validates :title, presence: true, length: { maximum: 30 }
end