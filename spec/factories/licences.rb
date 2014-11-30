# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :licence do
    account nil
    key nil
    expires_at nil
    expired_at nil
    sub_product nil
    product nil

    factory :active_licence do
      licence_state Licence::LICENCE_STATE_ACTIVE
    end

    factory :expired_licence do
      licence_state Licence::LICENCE_STATE_EXPIRED
    end

    factory :revoked_licence do
      licence_state Licence::LICENCE_STATE_REVOKED
    end
  end
end
