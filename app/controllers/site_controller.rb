class SiteController < ApplicationController
  def index
    @my_recipes = MyRecipe.order('created_at desc').page(params[:page]) if current_user
  end

  def search
    agent = Mechanize.new
    url = "http://www.epicurious.com/tools/searchresults?search=#{CGI.escape(params[:search])}&type=simple&sort=1&pageNumber=2&pageSize=30"
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
        box_image << "no image"
      else
        box_image << photo.attr('src').text
      end

      agent.back
      i +=1
    end


  end


  def result

  end

end
