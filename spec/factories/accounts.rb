# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do

    email { Faker::Internet.email }
    registered_to { Faker::Name.name }

  end
end
