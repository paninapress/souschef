class SiteController < ApplicationController
  def index
    @siterecipes = SiteRecipe.order('created_at desc').page(params[:page])


  end

  def search
    agent = Mechanize.new
    url = "http://www.epicurious.com/tools/searchresults?search=#{params[:food]}&type=simple&sort=1&pageNumber=1&pageSize=10"

    page = agent.get(url)
    box_preparation = []
    box_ingredient =[]
    box_image = []
    box_source = []


    temp = []
    page.search("a.recipeLnk").each do |link|
      temp << link.attr('href')
    end

    box_title = []
    page.search("a.recipeLnk").each do |link|
      box_title << link.text
    end

    i = 0
    while i < temp.size
      link = page.link_with(href: temp[i]).click
      box_preparation << link.parser.css("#preparation").text
      box_ingredient << link.parser.css("#ingredients").text
      box_source << link.parser.css(".source").text
      photo =  link.parser.css('img.photo')
      if photo.empty?
        box_image << '/images/articlesguides/howtocook/cookbooks/best-cookbooks-2012_612.jpg'
      else
        box_image << photo.attr('src').text
      end
      agent.back
      i +=1
    end

    i = 0
    while i < temp.size
      SiteRecipe.create(title: "#{box_title[i]}", ingredients: "#{box_ingredient[i]}", preparation: "#{box_preparation[i]}", image: "#{box_image[i]}", source: "#{box_source[i]}")
      i +=1
    end

    @recipes = SiteRecipe.last(10)

  end


  def show
    @recipes = SiteRecipe.find(params[:id])
    @image = @recipes.image
    @ingredients = @recipes.ingredients
    @preparation = @recipes.preparation
    @description =@ingredients + @preparation
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['AWSid'],
    :secret_access_key => ENV['AWSkey'])
    bucket = AWS::S3::Bucket.find("tennis-testing")
    @file = @description.to_file "en", "app/assets/audios/#{@recipes.title}.mp3"
    @audio = "app/assets/audios/#{@recipes.title}.mp3"
    @title = @recipes.title.gsub(/\s/,"+")
    AWS::S3::S3Object.store(@audio, open(@audio), 'tennis-testing')
  end

end
