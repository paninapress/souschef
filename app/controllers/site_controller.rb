class SiteController < ApplicationController
  def index
    @siterecipes = SiteRecipe.order('created_at desc').page(params[:page])
    #display some recipes that were created by former search results.
  end

  def search
    agent = Mechanize.new
    #url = "http://www.epicurious.com/tools/searchresults?search=#{params[:food]}&type=simple&sort=3&pageNumber=1&pageSize=12"
    url = "http://allrecipes.com/search/default.aspx?qt=k&wt=#{params[:food]}"
    url_params = params[:food]
    if url_params == nil
    #url = "http://www.epicurious.com/tools/searchresults?search=#{params[:foodnav]}&type=simple&sort=3&pageNumber=1&pageSize=12"
    url = "http://allrecipes.com/search/default.aspx?qt=k&wt=#{params[:foodnav]}" 
    end
    #Epicurus search url is passed the user's search input.
    page = agent.get(url)
    #mechanize is getting data from the url.
    box_preparation = []
    box_ingredient =[]
    box_image = []
    box_source = []
    #creating arrays to store the desired information from the search page for instantiating Site Recipes.


    temp = []
    #temporary array to hold links to every recipe found in the Epicurus search result.
    #page.search("a.recipeLnk").each do |link|
      page.search("a.title").each do |link|
      temp << link.attr('href')
      #Add each recipe's link to the temporary array so mechanize can visit those links.
    end

    box_title = []
    #page.search("a.recipeLnk").each do |link|
       page.search("a.title").each do |link|
      box_title << link.text
      #Add the recipe title to the array.
    end
    i = 0
    while i < temp.size
      link = page.link_with(href: temp[i]).click
      #mechanize will visit each link that was stored in the temporary array.
      box_preparation << link.parser.css("#preparation").text
      box_ingredient << link.parser.css("#ingredients").text
      box_source << link.parser.css(".source").text
      photo =  link.parser.css('img.photo')
      #mechanize parses the data from the page and gets the text value of the
      #desired css element. The data gets stored in the respective arrays.
      if photo.empty?
        #box_image << '/images/articlesguides/howtocook/cookbooks/best-cookbooks-2012_612.jpg'
        box_image << "http://images.media-allrecipes.com/userphotos/250x250/00/97/39/973972.jpg"

        #if the recipe page does not have an image, use some other Epicurus image.
      else
        box_image << photo.attr('src').text
      end
      agent.back
      #Mechanize goes back to the search result page, and then can
      #click on the next link in the temporary array.
      i +=1
    end

    i = 0
    while i < temp.size
      SiteRecipe.find_or_create_by(title: "#{box_title[i]}", ingredients: "#{box_ingredient[i]}", preparation: "#{box_preparation[i]}", image: "#{box_image[i]}", source: "#{box_source[i]}")
      i +=1
      #Create a Site Recipe from the data scraped from Epicurus by Mechanize. Should only create if a new entry.
    end

    @recipes = SiteRecipe.last(12)
  end


  def show
    @recipes = SiteRecipe.find(params[:id])
    @image = @recipes.image
    @ingredients = @recipes.ingredients
    @preparation = @recipes.preparation
    @description =@ingredients + @preparation
    #creating instance variables for the recipe page to be displayed in the view.
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET'])
    #Establishing connection to Amazon S3 account.
    bucket = AWS::S3::Bucket.find("tennis-testing")
    #Find S3 bucket that will store audio file.
    file = @description.to_file "en", "app/assets/audios/#{@recipes.title}.mp3"
    #Create an audio file from the recipe's ingredient list and cooking instructions. Set language and file path.
    @audio = "app/assets/audios/#{@recipes.title}.mp3"
    #Store the audio file's path.
    @title = @recipes.title.gsub(/\s/,"+")
    #Replace any spaces in the recipes title with addition symbol.
    AWS::S3::S3Object.store(@audio, open(@audio), 'tennis-testing')
    #Upload the audio file to S3.
    File.delete("#{Rails.root}/app/assets/audios/#{@recipes.title}.mp3")
    #Remove the local copy of audio file.

  end

end
