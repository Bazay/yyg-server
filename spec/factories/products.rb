# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do

    name { Faker::Commerce.product_name }
    product_type Product::PRODUCT_TYPE_GAME_MAKER
    base_price { Faker::Commerce.price }

  end
end
