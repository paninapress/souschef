class SiteController < ApplicationController
  def index
    @my_recipes = MyRecipe.order('created_at desc').page(params[:page]) if current_user
  end

  def search
    agent = Mechanize.new
    url = "http://www.epicurious.com/tools/searchresults?search=#{CGI.escape(params[:search])}&type=simple&sort=1&pageNumber=2&pageSize=30"
    page = agent.get(url)
    temp = []
    page.search("a.recipeLnk").each do |link|

      temp << link.attr('href')

      box_preparation = []
      box_ingredient =[]
      box_image = []
      box_title = []
      box_source = []
      i = 0
      while i < temp.size
        link = page.link_with(href: temp[i]).click
        box_preparation << link.parser.css("#preparation").text
        box_ingredient << link.parser.css("#ingredients").text
        agent.back
        i +=1
      end
    end
  end

  def result
  end

end
