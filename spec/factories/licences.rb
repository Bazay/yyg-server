# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :licence do
    account nil
    key "MyString"
    expires_at "2014-11-25 00:48:01"
    expired_at "2014-11-25 00:48:01"
    licence_state "MyString"
    licence_type "MyString"
    licence nil
  end
end
