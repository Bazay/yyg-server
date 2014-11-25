# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    email "MyString"
    registered_to "MyString"
    account_status "MyString"
  end
end
