require 'spec_helper'

describe Account do
  before :each do
    setup
  end

  context "GENERIC - " do
    it 'soft deletes the record'
  end

  context "VALIDATIONS - " do
    it 'validates_uniqueness_of email'
    it 'requires an email'
    it 'requires an account_status'
    it 'requires an included account_status'
  end

  context "HOOKS - " do
    it 'account is assigned a unique parent licence on creation'
    it 'sets account_state to "inactive" if none provided'
  end

  def setup
    @account = create(:account)
    @product = create(:product)
    @sub_product = create(:sub_product)
    @product.sub_products.push(@sub_product)
    @parent_licence = @account.parent_licence
  end
end
