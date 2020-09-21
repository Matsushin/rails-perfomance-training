class TasksController < ApplicationController
  def index
    @tasks = Task.order(id: :desc)
  end
end