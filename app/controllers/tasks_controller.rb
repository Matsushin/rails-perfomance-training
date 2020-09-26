class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:category, :users).order(id: :desc).page(params[:page]).per(200)
  end
end