# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub_product do
    name { Faker::Commerce.product_name }
    sub_product_type SubProduct::SUB_PRODUCT_TYPE_EXPORT
    base_price { Faker::Commerce.price }
  end
end
