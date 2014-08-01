class CommentsController < ApplicationController
	before_filter :load_commentable

  def index
  	@comments = @commentable.comments
  end

  def new
  	 @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(params[:comment])
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
end
