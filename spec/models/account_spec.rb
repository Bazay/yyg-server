require 'spec_helper'

describe Account do
  before :each do
    setup
  end

  context "GENERIC -" do
    it 'soft deletes the record' do
      account_id = @account.id
      @account.destroy
      expect(Account.unscoped.find(account_id)).to eql(@account)
    end
  end

  context "VALIDATIONS -" do
    it 'validates_uniqueness_of email' do
      expect{create(:account, email: @account.email)}.to raise_error
    end
    it 'requires a valid email' do
      #Blank
      expect{create(:account, email: "")}.to raise_error
      #Invalid syntax
      expect{create(:account, email: "hello")}.to raise_error
    end
  end

  context "HOOKS -" do
    it 'account is assigned a unique parent licence on creation' do
      new_account = create(:account)
      expect(new_account.parent_licence.present?).to eql(true)
    end
    it 'derives account_state from parent_licence state' do
      expect(@account.get_account_state).to eql(@account.parent_licence.licence_state)
    end
  end

  def setup
    @account = create(:account)
    @product = create(:product)
    @sub_product = create(:sub_product)
    @product.sub_products.push(@sub_product)
    @parent_licence = @account.parent_licence
  end
end
