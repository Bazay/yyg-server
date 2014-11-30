require 'spec_helper'

describe Licence do
  before :each do
    setup
  end

  context "GENERIC -" do
    it 'soft deletes the record' do
      parent_id = @parent_licence.id
      @parent_licence.destroy
      expect(Licence.unscoped.find(parent_id)).to eql(@parent_licence)
    end
  end

  context "HOOKS -" do
    it 'generates a uniq, uuid-based key for the record on creation' do
      sub_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      expect(sub_licence.key.nil?).to eql(false)
    end
    it 'sets expires_at on creation' do
      sub_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      expect(sub_licence.expires_at.nil?).to eql(true)
    end
  end

  context "VALIDATIONS -" do
    it 'validates_uniqueness_of key' do
      sub_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      sub_licence.key = @parent_licence.key
      expect(sub_licence.valid?).to eql(false)
    end
    it 'requires a key' do
      sub_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      sub_licence.key = nil
      sub_licence.save
      expect(sub_licence.errors.full_messages.join(' ').downcase.include?('key')).to eql(true)
    end
    it 'requires an included licence_state' do
      sub_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      sub_licence.licence_state = nil
      sub_licence.save
      expect(sub_licence.errors.full_messages.join(' ').downcase.include?('licence state')).to eql(true)
    end
    it 'has valid relations' do
      #Sub licence must have relation to either a product or sub product
      FactoryGirl.build(:sub_licence, account: @account).should_not be_valid  
      #A product licence does not have a sub_product association   
      FactoryGirl.build(:sub_licence, account: @account, product: @product).should be_valid
      #Sub product licences must have relations to both a sub_product and product
      FactoryGirl.build(:sub_licence, account: @account, sub_product: @sub_product).should_not be_valid
      FactoryGirl.build(:sub_licence, account: @account).should_not be_valid
      FactoryGirl.build(:parent_licence, account: @account).should be_valid
      FactoryGirl.build(:parent_licence).should_not be_valid
    end
    it 'originally assigned key cannot be changed - raises error' do
      sub_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      sub_licence.key = SecureRandom.uuid
      expect(sub_licence.save).to eql(false)
      expect(sub_licence.errors.full_messages.join(' ').downcase.include?('key value cannot be changed once assigned')).to eql(true)
    end
  end

  context "SCOPES -" do
    it 'excludes deleted records by default' do
      @parent_licence.destroy
      sub_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      not_deleted_licences = Licence.unscoped.where(deleted: false).pluck(:id).sort
      expect(Licence.pluck(:id).sort).to eql(not_deleted_licences)
    end
    it 'product_licences scope works as expected' do
      product_licence = create(:sub_licence, account: @account, product: @product)
      sub_product_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      product_licences = SubLicence.unscoped.where(deleted: false).where('product_id IS NOT NULL AND sub_product_id IS NULL').pluck(:id).sort
      expect(SubLicence.product_licences.pluck(:id).sort).to eql(product_licences)
    end
    it 'sub_product_licences scope works as expected' do
      product_licence = create(:sub_licence, account: @account, product: @product)
      sub_product_licence = create(:sub_licence, sub_product: @sub_product, account: @account, product: @product)
      sub_product_licences = SubLicence.unscoped.where(deleted: false).where('product_id IS NOT NULL AND sub_product_id IS NOT NULL').pluck(:id).sort
      expect(SubLicence.sub_product_licences.pluck(:id).sort).to eql(sub_product_licences)
    end
  end

  context "METHODS -" do
    it 'can be set to active' do
      @parent_licence.set_to_active
      expect(@parent_licence.active?).to eql(true)
    end
    it 'can be set to revoked' do
      @parent_licence.set_to_revoked
      expect(@parent_licence.revoked?).to eql(true)
    end
    it 'can be set to expired' do
      @parent_licence.set_to_expired
      expect(@parent_licence.expired?).to eql(true)
    end
    it 'expiry date can be set by a valid expiry_key' do
      expect(@parent_licence.set_expires_at('invalid_expiry')).to eql(false)
      expect(@parent_licence.set_expires_at(Licence::SHORT_EXPIRY)).not_to eql(false)
    end
  end

  context "OBSERVER -" do
    it 'correctly sets up sub_product licences after the creation of a product licence' do
      new_account = create(:account)

      new_product = create(:product)

      sub_products = []
      3.times do 
        sub_products << create(:sub_product)
      end
      new_product.sub_products << sub_products

      new_product_licence = create(:sub_licence, product: new_product, account: new_account)

      expect(new_account.sub_product_licences.select{|sp_licence| sp_licence.account == new_product_licence.account && 
        sp_licence.product == new_product && sp_licence.licence_state == new_product_licence.licence_state && 
        sp_licence.expires_at == new_product_licence.expires_at}.map(&:sub_product_id).sort).to eql(new_product.sub_products.pluck(:id).sort)
    end
    it 'ensures duplicate sub_licences are not created' do
      #Here, we create 2 product both with the sub_product '@sub_product'.
      # A second sub_licence should not be generated for this sub_product when the second product gets added to the account
      product_licence = create(:sub_licence, product: @product, account: @account)

      new_product = create(:product)
      new_sub_product = create(:sub_product)
      sub_products = [new_sub_product, @sub_product]
      new_product.sub_products << sub_products

      new_product_licence = create(:sub_licence, product: new_product, account: @account)

      expect(@account.sub_product_licences.select{|sp_licence| sp_licence.account == new_product_licence.account && 
        (sp_licence.product == new_product || sp_licence.product == @product) && 
        (sp_licence.licence_state == new_product_licence.licence_state || sp_licence.licence_state == product_licence.licence_state) && 
        (sp_licence.expires_at == new_product_licence.expires_at || sp_licence.expires_at == product_licence.expires_at)}.map(&:sub_product_id).sort).to eql(sub_products.map(&:id).sort)
    end
  end

  #TEST METHODS
  def setup
    @account = create(:account)
    @product = create(:product)
    @sub_product = create(:sub_product)
    @product.sub_products.push(@sub_product)
    @parent_licence = @account.parent_licence
  end
end
