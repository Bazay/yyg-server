# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :parent_licence do
    account nil
    key nil
    expires_at nil
    expired_at nil

    factory :active_parent_licence do
      licence_state Licence::LICENCE_STATE_ACTIVE
    end

    factory :expired_parent_licence do
      licence_state Licence::LICENCE_STATE_EXPIRED
    end

    factory :revoked_parent_licence do
      licence_state Licence::LICENCE_STATE_REVOKED
    end
  end
end
