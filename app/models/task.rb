class Task < ApplicationRecord
  belongs_to :category

  validates :title, presence: true, length: { maximum: 30 }
end