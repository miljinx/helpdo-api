class PrivateTodosController < ApplicationController
  before_action :authenticate_user
  before_action :set_todo, only: [:show, :update, :destroy]
  before_action :authorize, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = current_user.todos.all
    json_response(@todos)
  end

  # GET /todos/:id
  def show
    json_response(@todo)
  end

  # POST /todos
  def create
    @todo = current_user.todos.create!(todo_params)
    json_response(@todo, :created)
  end

  # PUT /todos/:id
  def update
    @todo.update(todo_params)
    head :no_content
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def todo_params
    params.permit(:title, :type)
  end

  def set_todo
    @todo = PrivateTodo.find(params[:id])
  end

  def authorize
    if @todo.creator.id != current_user.id
      json_response('Not authorized to view or edit this Todo', :unauthorized)
    end
  end
end
