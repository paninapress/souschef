class MyRecipesController < ApplicationController
  require 'net/http'
  require 'json'
  require 'tts'


  before_action :set_my_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /my_recipes
  def index
    @myrecipes = current_user.my_recipes.order('created_at desc').page(params[:page])
  end

  # GET /my_recipes/1
  def show
    @myrecipes = MyRecipe.find(params[:id])
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAI6AECUXY23A6B56Q',
    :secret_access_key => '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',)
    bucket = AWS::S3::Bucket.find("tennis-testing")
    @file = @myrecipes.description.to_file "en", "app/assets/audios/#{@myrecipes.title}.mp3"
    @myrecipes.speechlink = "app/assets/audios/#{@myrecipes.title}.mp3"
    @title = @myrecipes.title.gsub(/\s/,"+")
    AWS::S3::S3Object.store(@myrecipes.speechlink, open(@myrecipes.speechlink), 'tennis-testing')
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

  #
  #
  #web search can't take spaces, need to add +sign between words.
  ###typhoeus is will get it as a hash
  ####need json.
  ###webknox/recipes api
  def search
    food = params[:search]
    url = "http://api.yummly.com/v1/api/recipes?_app_id=4319bda9&_app_key=699fc2abb535f3a2cb846c2971e5ff4d&q=#{food}&maxResult=10&start=10"
    resp = Net::HTTP.get_response(URI(url))
    @data = JSON.parse(resp.body)
    puts @data["matches"][1]["ingredients"]
    @data["matches"][1]["ingredients"].to_s.to_file "en", "app/assets/audios/recipe_id.mp3"

    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAI6AECUXY23A6B56Q',
    :secret_access_key => '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',)
    bucket = AWS::S3::Bucket.find("tennis-testing")
    file = 'app/assets/audios/recipe_id.mp3'
    AWS::S3::S3Object.store(file, open(file), 'tennis-testing')


    #  @data["ingredientLines"].to_file "en"
    #####need to specify entire folder directory to save mp3 file that's generated. app/assets/audios/filename
    ###when adding file to s3 bucket, will need whole file path as well. Like /User/calvinlam/Desktop/filename
  end

  # PATCH/PUT /my_recipes/1
  def update
    if @myrecipes.update(my_recipes_params)
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
