# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_sub_product do
    name "MyString"
    sub_product_type "MyString"
    base_price 1.5
    account_id 1
    sub_product_id 1
    account_product_id 1
  end
end
