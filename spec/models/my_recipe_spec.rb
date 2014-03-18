require 'spec_helper'

describe MyRecipe do
  it "is valid with a title and description." do
    expect(build(:my_recipe)).to be_valid
  end


  it "is invalid without a title." do
    my_recipe = build(:my_recipe, title: nil)
    expect(my_recipe).to have(1).errors_on(:title)
  end

  it "is invalid without a description." do
    my_recipe = build(:my_recipe, description: nil)
    expect(my_recipe).to have(1).errors_on(:description)
  end

end
