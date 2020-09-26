class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:users).order(id: :desc).page(params[:page]).per(200)
    @category_names = Category.pluck(:id, :name).to_h
  end
end