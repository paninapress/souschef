require 'spec_helper'

describe MyRecipe do
  it "is valid with a title and description." do
    expect(FactoryGirl.build(:my_recipe)).to be_valid
  end


  it "is invalid without a title." do
    expect(MyRecipe.new(title: nil)).to have(1).errors_on(:title)
  end

  it "is invalid without a description." do
    expect(MyRecipe.new(description: nil)).to have(1).errors_on(:description)
  end

end
