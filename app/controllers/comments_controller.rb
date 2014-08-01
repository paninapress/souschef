class CommentsController < ApplicationController
	before_filter :load_commentable
	before_action :authenticate_user!

  def index
  	@comments = @commentable.comments
  end

  def new
  	 @comment = @commentable.comments.new
  end

  def create
  	 current_user.username = :username
    @comment = @commentable.comments.create!(params.require(:comment).permit(:content, current_user.username = :username))
    if @comment.save
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end

  private

  def load_commentable
  	resource, id = request.path.split('/')[1,2]
  	if resource == "site"
  	resource = resource.singularize.classify + "Recipe"
  	resource = resource.constantize
  else
  	resource = resource.singularize.classify.constantize
  end
  	@commentable = resource.find(id)
  end

  def comment_params
  	params.require(:comment).permit(:content, :username)
	end
end

