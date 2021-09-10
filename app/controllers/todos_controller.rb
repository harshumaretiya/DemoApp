class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]
  before_action :set_todolist, only: %i[ update new destroy ]
  before_action :authenticate_user!

  # GET /todos or /todos.json
  def index
    redirect_to :action => 'new'
  end

  # GET /todos/1 or /todos/1.json
  def show
    @comment = Comment.new
    @comments = @todo.comments.order("created_at DESC")
  end

  # GET /todos/new
  def new
    @todo =  current_user.todos.build
    @comment = Comment.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @todo = current_user.todos.build(todo_params)
    respond_to do |format|
      if @todo.save
        format.js
      else
        format.js { redirect_back fallback_location: root_path, alert: "#{@todo.errors.full_messages.to_sentence}" }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    redirect_to :action => 'new' if @todo.update(todo_params)
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy
    respond_to do |format|
      format.js
    end
  end

  #delete Attached Image
  def delete_image_attachment
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge # or use purge_later
    if !attachment.destroyed?
      redirect_back fallback_location: root_path, alert: "Attachment was not destroyed."
    else
      redirect_back fallback_location: root_path, notice: "Attachment destroyed successfully."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:title, :desc, :status, :user_id, :due_date, files: [])
    end

    def set_todolist
      @todo_all = current_user.todos.all
    end
end
