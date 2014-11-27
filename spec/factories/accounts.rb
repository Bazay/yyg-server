# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :valid_account do
    email { Faker::Internet.email }
    registered_to { Faker::Name.name }
    account_status Account::ACCOUNT_STATUS_ACTIVE
  end

  factory :invalid_account do
    email nil
    registered_to nil
    account_status nil
  end
end
