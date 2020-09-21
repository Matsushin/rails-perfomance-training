unless Category.exists?
  # カテゴリ作成
  ActiveRecord::Base::transaction do
    %w[仕事 学習 プライベート その他].each do |name|
      Category.create!(name: name)
    end
  end
end

unless User.exists?
  # ユーザ作成
  ActiveRecord::Base::transaction do
    10.times do |index|
      User.create!(name: "テストユーザ#{index + 1}")
    end
  end
end

unless Task.exists?
  category_ids = Category.all.pluck(:id)
  p 'Start import tasks'
  # タスク50万件作成
  10.times do |index_1|
    tasks = 50_000.times.map do |index_2|
      index = index_1 * 50_000 + index_2 + 1
      {
          title: "タスクタイトル#{index}",
          body: "タスク内容",
          status: Task.statuses.values.sample,
          category_id: category_ids.sample
      }
    end
    Task.import! tasks
    p "Imported #{(index_1 + 1) * 50_000}/1000000 records"
  end

  p 'End import tasks'
end

unless TaskAssignee.exists?
  # タスク割り当て50万件作成
  user_ids = User.all.pluck(:id)
  p 'Start import task_assignees'
  index = 0
  task_count = Task.count
  Task.find_in_batches do |tasks|
    index += 1
    task_assignees = tasks.map do |task|
      user_ids.sample(rand(1..3)).map do |user_id|
        {
            task_id: task.id,
            user_id: user_id
        }
      end
    end.flatten
    TaskAssignee.import! task_assignees
    p "Imported #{index * 1000}/#{task_count} records"
  end
  p 'End import task_assignees'
end