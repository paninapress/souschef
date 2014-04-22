class ProfilesController < ApplicationController
  def index
    @users = User.page(params[:page])
  end

  def show
    if @user = User.where(id: params[:id]).first # returns User object. Returns nil when not found.
      @myrecipes = @user.my_recipes.page(params[:page]) #to display user's recipe.
    else
      flash[:alert] = 'Profile not found.'
      redirect_to profiles_path
    end
  end

end
