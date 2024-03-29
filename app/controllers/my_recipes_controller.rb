class MyRecipesController < ApplicationController
  require 'net/http'
  require 'json'
  require 'tts'
  require 'nokogiri'
  require 'open-uri'

  require 'mechanize'

  before_action :set_my_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  # GET /my_recipes
  def index
    @myrecipes = current_user.my_recipes.order('created_at desc').page(params[:page])
    @username = current_user.username
  end

  # GET /my_recipes/1
  def show
    @username = current_user.username
    @recipes = MyRecipe.find(params[:id])
    @image = @recipes.photo
    @ingredients = @recipes.ingredients
    @preparation = @recipes.preparation
    @description =@ingredients + @preparation
    @calories = @recipes.calories
    @protein = @recipes.protein
    @fat = @recipes.fat
    @saturated = @recipes.saturated
    @poly = @recipes.poly
    @sodium = @recipes.sodium
    @mono= @recipes.mono
    @cholesterol = @recipes.cholesterol
    @carb = @recipes.carb
    @fiber = @recipes.fiber
    @serving = @recipes.servings
    #@ingredients = @myrecipes.ingredients
    #@preparation = @myrecipes.preparation
    #@description =@ingredients + @preparation
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET'])
    #Establish connection to Amazon S3 account.
    bucket = AWS::S3::Bucket.find("tennis-testing")
    #Find S3 bucket to store audio file.
    @file = @myrecipes.description.to_file "en", "app/assets/audios/#{@myrecipes.title+@username}.mp3"
    #Create the audio file of the recipe's cooking information and set language and file path.
    @myrecipes.speechlink = "app/assets/audios/#{@myrecipes.title+@username}.mp3"
    #Add the local path of audio file to the recipe object.
    @title = @myrecipes.title.gsub(/\s/,"+")+@username
    AWS::S3::S3Object.store(@myrecipes.speechlink, open(@myrecipes.speechlink), 'tennis-testing')
    #Upload the recipe audio file to S3.
    File.delete("#{Rails.root}/app/assets/audios/#{@myrecipes.title+@username}.mp3")
    @commentable = @recipes
  @comments = @commentable.comments
  @comment = Comment.new
  if current_user == nil
   @current_user = User.first
  else
    @current_user = current_user.id   
  end

@rating = Rating.where(site_recipe_id: @recipes.id, user_id: @current_user).first unless @rating 
@rating = Rating.create(site_recipe_id: @recipes.id, user_id: @current_user, score: 0)
  end

  # GET /my_recipes/new
  def new
    @myrecipes = current_user.my_recipes.new
  end

  # GET /my_recipes/1/edit
  def edit
  end

  # POST /my_recipes
  def create
    @myrecipes = current_user.my_recipes.new(my_recipes_params)
    @myrecipes.description = @myrecipes.ingredients+@myrecipes.preparation
    if @myrecipes.save
      redirect_to @myrecipes, notice: 'Recipe was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /my_recipes/1
  def update
    @username = current_user.username
    @myrecipes = MyRecipe.find(params[:id])
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET'])
    #Establish connection to S3.
    bucket = AWS::S3::Bucket.find("tennis-testing")
    @myrecipes.speechlink = "app/assets/audios/#{@myrecipes.title+@username}.mp3"
    @title = @myrecipes.title.gsub(/\s/,"+")+@username
    AWS::S3::S3Object.delete(@myrecipes.speechlink, 'tennis-testing')
    #Delete the old audio file from S3 bucket.
    if @myrecipes.update(my_recipes_params)
      @file = @myrecipes.description.to_file "en", "app/assets/audios/#{@myrecipes.title+@username}.mp3"
      #Create a new audio file from updated recipe information.
      @myrecipes.speechlink = "app/assets/audios/#{@myrecipes.title+@username}.mp3"
      AWS::S3::S3Object.store(@myrecipes.speechlink, open(@myrecipes.speechlink), 'tennis-testing')
      #Upload the new audio file to S3.
      File.delete("#{Rails.root}/app/assets/audios/#{@myrecipes.title+@username}.mp3")
      #Delete the local audio file.
      redirect_to @myrecipes, notice: 'Recipe was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /my_recipes/1
  def destroy
    @myrecipes.destroy
    redirect_to my_recipes_url, notice: 'Recipe was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_my_recipe
    unless @myrecipes = current_user.my_recipes.where(id: params[:id]).first
      flash[:alert] = 'Recipe not found.'
      redirect_to root_url
    end
  end

  # Only allow a trusted parameter "white list" through.
  def my_recipes_params
    params.require(:my_recipe).permit(:title, :description, :user_id, :photo, :search, :ingredients, :preparation, :servings, :time, :calories, :fat, :saturated, :poly, :mono, :carb, :protein, :sodium, :fiber, :cholesterol)
  end
end
