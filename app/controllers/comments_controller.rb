class CommentsController < ApplicationController
  before_action :set_todo
  before_action :authenticate_user!

  def create
    @comment = @todo.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.js { redirect_back fallback_location: root_path, notice: "Successfully comment added." }
      else
        format.js { redirect_back fallback_location: root_path, alert: "#{@comment.errors.full_messages.to_sentence}" }
      end
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body, :todo_id)
  end

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

end
