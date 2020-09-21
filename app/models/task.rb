class Task < ApplicationRecord
  belongs_to :category
  has_many :task_assignees
  has_many :users, through: :task_assignees

  validates :title, presence: true, length: { maximum: 30 }

  enum status: { waiting: 0, doing: 1, completed: 2, archived: 3 }

  def self.waiting_count_group_by_category
    start_time = Time.now
    tasks_count = Task.completed
                      .includes(:category)
                      .group(:category_id)
                      .select('count(*) as count, category_id')
                      .map do |task|
      {
          count: task.count,
          category_name: task.category.name,
          category_id: task.category_id
      }
    end
    p "処理時間 #{Time.now - start_time}s"
    tasks_count
  end
end