class CreateTaskAssignees < ActiveRecord::Migration[6.0]
  def change
    create_table :task_assignees do |t|
      t.references :task, index: true, null: false, foreign_key: true
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
    add_index :task_assignees, [:task_id, :user_id], unique: true
  end
end
