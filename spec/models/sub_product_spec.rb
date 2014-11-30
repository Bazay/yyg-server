require 'spec_helper'

describe SubProduct do
  before :each do
    setup
  end

  context "GENERIC -" do
    it 'soft deletes the record' do
      sub_product_id = @sub_product.id
      @sub_product.destroy
      expect(SubProduct.unscoped.find(sub_product_id)).to eql(@sub_product)
    end
  end

  context "HOOKS -" do
    #No tests
  end

  context "VALIDATIONS -" do
    it 'valid sub product shouldn\'t raise any errors' do
      expect{create(:sub_product)}.not_to raise_error
    end
    it 'validates_uniqueness_of name' do
      expect{create(:sub_product, name: @sub_product.name)}.to raise_error
    end
    it 'requires base_price to be equal or greater than 0' do
      expect{create(:sub_product, base_price: -1)}.to raise_error
    end
    it 'requires an included sub_product_type' do
      expect{create(:sub_product, sub_product_type: "invalid_product_type")}.to raise_error
      expect{create(:sub_product, sub_product_type: SubProduct::SUB_PRODUCT_TYPES.first)}.not_to raise_error
    end
  end

  context "SCOPES -" do
    it 'export scope works as expected' do
      3.times do 
        create(:sub_product, sub_product_type: SubProduct::SUB_PRODUCT_TYPE_EXPORT)
      end
      expect(SubProduct.unscoped.where(deleted: false, sub_product_type: SubProduct::SUB_PRODUCT_TYPE_EXPORT).pluck(:id).sort).to eql(SubProduct.export.pluck(:id).sort)
    end
    it 'compiler scope works as expected' do
      3.times do 
        create(:sub_product, sub_product_type: SubProduct::SUB_PRODUCT_TYPE_COMPILER)
      end
      expect(SubProduct.unscoped.where(deleted: false, sub_product_type: SubProduct::SUB_PRODUCT_TYPE_COMPILER).pluck(:id).sort).to eql(SubProduct.compiler.pluck(:id).sort)
    end
  end

  context "METHODS -" do
    #No tests
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
