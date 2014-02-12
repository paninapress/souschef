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
  end

  # GET /my_recipes/1
  def show
    @username = current_user.username
    @myrecipes = MyRecipe.find(params[:id])
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['access_key_id'],
    :secret_access_key => ENV['secret_access_key'])
    bucket = AWS::S3::Bucket.find("tennis-testing")
    @file = @myrecipes.description.to_file "en", "app/assets/audios/#{@myrecipes.title+@username}.mp3"
    @myrecipes.speechlink = "app/assets/audios/#{@myrecipes.title+@username}.mp3"
    @title = @myrecipes.title.gsub(/\s/,"+")+@username
    AWS::S3::S3Object.store(@myrecipes.speechlink, open(@myrecipes.speechlink), 'tennis-testing')
    File.delete("#{Rails.root}/app/assets/audios/#{@myrecipes.title+@username}.mp3")
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
      :access_key_id     => ENV['AWSid'],
    :secret_access_key => ENV['AWSkey'])
    bucket = AWS::S3::Bucket.find("tennis-testing")
    @myrecipes.speechlink = "app/assets/audios/#{@myrecipes.title+@username}.mp3"
    @title = @myrecipes.title.gsub(/\s/,"+")+@username
    AWS::S3::S3Object.delete(@myrecipes.speechlink, 'tennis-testing')
    if @myrecipes.update(my_recipes_params)
      @file = @myrecipes.description.to_file "en", "app/assets/audios/#{@myrecipes.title+@username}.mp3"
      @myrecipes.speechlink = "app/assets/audios/#{@myrecipes.title+@username}.mp3"
      AWS::S3::S3Object.store(@myrecipes.speechlink, open(@myrecipes.speechlink), 'tennis-testing')
      File.delete("#{Rails.root}/app/assets/audios/#{@myrecipes.title+@username}.mp3")
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
    params.require(:my_recipe).permit(:title, :description, :user_id, :photo, :search)
  end
end
