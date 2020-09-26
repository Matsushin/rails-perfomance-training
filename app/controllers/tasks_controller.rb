class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:task_assignees).order(id: :desc).page(params[:page]).per(200)
    @user_names = User.pluck(:id, :name).to_h
  end
end