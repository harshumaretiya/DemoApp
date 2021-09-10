# frozen_string_literal: true

class Api::V1::TodosController < Api::V1::AuthenticatedController
  before_action :set_todo, only: [:update, :destroy, :show]


  # GET  /api/v1/todos
  def index
    begin
      todos = @current_user.
                todos.
                order('created_at DESC').
                paginate(page: params[:page], per_page: 10) 
    rescue => e 
      render_exception(e, 422) && return
    end
    json_response(TodoSerializer.new(todos).serializable_hash[:data].map {|todo| todo[:attributes]},MetaGenerator.new.generate!(todos))
  end

  #POST /api/v1/todos
  def create
    begin
      todo = @current_user.todos.create!(todo_params)
    rescue => e 
      render_exception(e, 422) && return
    end
    json_response(TodoSerializer.new(todo).serializable_hash[:data][:attributes])
  end

  #PUT /api/v1/todos/:id
  def update
    begin
      @todo.update!(todo_params)  
    rescue => e 
      render_exception(e, 422) && return
    end
    json_response(TodoSerializer.new(@todo).serializable_hash[:data][:attributes])
  end

  #GET /api/v1/todos/:id
  def show
    begin
      # binding.pry
      comment = @todo.comments.all
      todo_comments = @todo.attributes.merge({comments: comment})
  
    rescue => e 
      render_exception(e, 422) && return
    end
    # json_response(TodoSerializer.new(@todo,todo_comments).serializable_hash[:data][:attributes])
    json_response(TodoSerializer.new(@todo).serializable_hash[:data][:attributes])

  end

  #DELETE /api/v1/todos/:id
  def destroy
    begin
      @todo.destroy
    rescue => e 
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end

  #private methods
  private

  def todo_params
    params.require(:todo).permit(:title, :desc, :status, :user_id, :due_date, files: [])
  end
  
  def set_todo
    @todo = Todo.find(params[:id])
  end
end 
