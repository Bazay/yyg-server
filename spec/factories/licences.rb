# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :licence do
    account nil
    key nil
    expires_at nil
    expired_at nil
    sub_product nil
    product nil

    factory :sub_licence do
      licence_state Licence::LICENCE_STATE_INACTIVE
      licence_type Licence::LICENCE_TYPE_SUB
    end

    factory :parent_licence do
      licence_state Licence::LICENCE_STATE_INACTIVE
      licence_type Licence::LICENCE_TYPE_PARENT
    end

    factory :active_licence do
      licence_state Licence::LICENCE_STATE_ACTIVE
      licence_type Licence::LICENCE_TYPE_SUB
    end

    factory :expired_licence do
      licence_state Licence::LICENCE_STATE_EXPIRED
      licence_type Licence::LICENCE_TYPE_SUB
    end

    factory :revoked_licence do
      licence_state Licence::LICENCE_STATE_REVOKED
      licence_type Licence::LICENCE_TYPE_SUB
    end
  end
end
