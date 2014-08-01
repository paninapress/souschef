# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    site_recipe nil
    my_recipe nil
    user nil
    score 1
    default "MyString"
  end
end
