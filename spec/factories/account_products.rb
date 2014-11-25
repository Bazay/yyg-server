# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_product do
    name "MyString"
    product_type "MyString"
    base_price 1.5
    account_id 1
    product_id 1
  end
end
