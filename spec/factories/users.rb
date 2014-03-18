FactoryGirl.define do
  factory :user do
    username 'Test User'
    email 'example@example.com'
    password 'changeme'
    password_confirmation 'changeme'
  end
end
