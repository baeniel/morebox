class CommentsController < ApplicationController

  def new
  end

  def create
    @item = Item.find(params[:comment][:item_id])
    comment = Comment.new(comment_params)
    comment.user = current_user
    comment.save
  end

  def update
  end

  def edit
  end

  def destroy
    @comment = Comment.find params[:id]
    @item = @comment.item
    @comment.destroy
    render :create
  end

  private

  def comment_params
    params.require(:comment).permit(:item_id, :body)
  end

end
