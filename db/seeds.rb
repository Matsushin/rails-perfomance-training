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
  # タスク作成
  tasks = 10000.times.map do |index|
    {
      title: "タスクタイトル#{index + 1}",
      body: "タスク内容",
      category_id: category_ids.sample
    }
  end
  Task.import! tasks

end

unless TaskAssignee.exists?
  # タスク割り当て作成
  user_ids = User.all.pluck(:id)
  task_assignees = Task.all.map do |task|
    user_ids.sample(rand(1..3)).map do |user_id|
      {
          task_id: task.id,
          user_id: user_id
      }
    end
  end.flatten
  p task_assignees
  TaskAssignee.import! task_assignees
end