# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub_product do
    name "MyString"
    product_id nil
    sub_product_type "MyString"
    base_price 1.5
  end
end
