class SiteController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    @siterecipes = SiteRecipe.order('created_at desc').page(params[:page])
    #display some recipes that were created by former search results.
  end

  def search
    agent = Mechanize.new
    
    url = "http://www.epicurious.com/tools/searchresults?search=#{params[:food]}&type=simple&sort=3&pageNumber=1&pageSize=12"
    url_params = params[:food]
    if url_params == nil
    url = "http://www.epicurious.com/tools/searchresults?search=#{params[:foodnav]}&type=simple&sort=3&pageNumber=1&pageSize=12"
    end
    #Epicurus search url is passed the user's search input.
    page = agent.get(url)
    #mechanize is getting data from the url.
    box_preparation = []
    box_ingredient =[]
    box_ingredient_temp =[]
    box_image = []
    box_source = []
    box_nutrition = []
    box_summary = []
    box_calorie = []
    box_serving = []
    box_total_time =[]
    box_active_time = []
    box_fat = []
    box_poly= []
    box_mono = []
    box_saturated = []
    box_protein = []
    box_carb= []
    box_sodium = []
    box_fiber = []
    box_cholesterol = []

    #creating arrays to store the desired information from the search page for instantiating Site Recipes.


    temp = []
    #temporary array to hold links to every recipe found in the Epicurus search result.
    page.search("a.recipeLnk").each do |link|
      temp << link.attr('href')
      #Add each recipe's link to the temporary array so mechanize can visit those links.
    end

    box_title = []
    page.search("a.recipeLnk").each do |link|
      box_title << link.text
      #Add the recipe title to the array.
    end

    i = 0
    while i < temp.size
      link = page.link_with(href: temp[i]).click
      #mechanize will visit each link that was stored in the temporary array.
      box_preparation << link.parser.css("#preparation").text

      link.search(".ingredient").each do |food|
        box_ingredient_temp << food.text
      end
      box_ingredient_temp = box_ingredient_temp.join(",")
      box_ingredient << box_ingredient_temp.gsub(",","\n")
      
      box_source << link.parser.css(".source").text
        link.search(".nutriData").each do |nutrition|
          box_nutrition << nutrition.text
        end
            j = 0
            while j < box_nutrition.size
              box_nutrition[j].sub!(/\n/,"")
              if box_nutrition[j] == nil
                box_nutrition[j] = "N/A"
                end
               j +=1
            end

       
if box_nutrition[0].nil?
  box_nutrition[0] = "N/A" 
  box_calorie << box_nutrition[0]  
  else  
    box_calorie << box_nutrition[0]
  end

if box_nutrition[1].nil?
  box_nutrition[1] = "N/A" 
  box_carb << box_nutrition[1]  
  else  
    box_carb << box_nutrition[1]
  end
    

    if box_nutrition[2].nil?
  box_nutrition[2] = "N/A" 
  box_fat << box_nutrition[2]  
  else  
    box_fat << box_nutrition[2]
  end

    if box_nutrition[3].nil?
  box_nutrition[3] = "N/A" 
  box_protein << box_nutrition[3]  
  else  
    box_protein << box_nutrition[3]
  end
    
    if box_nutrition[4].nil?
  box_nutrition[4] = "N/A" 
  box_saturated << box_nutrition[4]  
  else  
    box_saturated << box_nutrition[4]
  end
    
    if box_nutrition[5].nil?
  box_nutrition[5] = "N/A" 
  box_sodium << box_nutrition[5]  
  else  
    box_sodium << box_nutrition[5]
  end

if box_nutrition[6].nil?
  box_nutrition[6] = "N/A" 
  box_poly << box_nutrition[6]  
  else  
    box_poly << box_nutrition[6]
  end

    if box_nutrition[7].nil?
  box_nutrition[7] = "N/A" 
  box_fiber << box_nutrition[7]  
  else  
    box_fiber << box_nutrition[7]
  end

    if box_nutrition[8].nil?
  box_nutrition[8] = "N/A" 
  box_mono << box_nutrition[8]  
  else  
    box_mono << box_nutrition[8]
  end

    if box_nutrition[9].nil?
  box_nutrition[9] = "N/A" 
  box_cholesterol << box_nutrition[9]  
  else  
    box_cholesterol << box_nutrition[9]
  end



    if link.parser.css("p.summary_data")[0].nil?
      box_serving_temp = "N/A"
    else
    box_serving_temp = link.parser.css("p.summary_data")[0].text
  end
    box_serving_temp = box_serving_temp.strip
    box_serving_temp =  box_serving_temp.gsub("\n","")
    box_serving << box_serving_temp.gsub("yieldMakes","")
    box_active_time = "N/A"
    box_total_time = "N/A"
      photo =  link.parser.css('img.photo')
      #mechanize parses the data from the page and gets the text value of the
      #desired css element. The data gets stored in the respective arrays.
      if photo.empty?
        box_image << '/images/articlesguides/howtocook/cookbooks/best-cookbooks-2012_612.jpg'
        #if the recipe page does not have an image, use some other Epicurus image.
      else
        box_image << photo.attr('src').text
      end
      box_ingredient_temp = []

      agent.back
      #Mechanize goes back to the search result page, and then can
      #click on the next link in the temporary array.
      i +=1
    end
    i = 0
    while i < temp.size
      SiteRecipe.find_or_create_by(title: "#{box_title[i]}", 
        ingredients: "#{box_ingredient[i]}", 
        preparation: "#{box_preparation[i]}", 
        image: "#{box_image[i]}", 
        source: "#{box_source[i]}", 
        fat: "#{box_fat[i]}", 
        calories: "#{box_calorie[i]}", 
        protein: "#{box_protein[i]}",
      saturated: "#{box_saturated[i]}",
      sodium: "#{box_sodium[i]}",
      poly: "#{box_poly[i]}",
      mono: "#{box_mono[i]}",
      carb: "#{box_carb[i]}",
      fiber: "#{box_fiber[i]}",
      cholesterol: "#{box_cholesterol[i]}")
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