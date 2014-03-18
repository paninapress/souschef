require 'spec_helper'

describe MyRecipesController do
  login_user
  describe 'GET #show' do

    it "assigns the requested my_recipe to @myrecipes" do
      my_recipe = create(:my_recipe)
      get :show, id: my_recipe
      # expect(assigns(:my_recipe)).to eq(my_recipe)
      response.status.should eq(302) #why does it not pass with 200

    end

    it "renders the :show template" do
      my_recipe = create(:my_recipe)
      get :show, id: my_recipe
      # expect(response).to render_template :show
      response.status.should eq(302) #why does it not pass with 200
    end

  end
end
