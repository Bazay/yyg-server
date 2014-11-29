require 'spec_helper'

describe Product do
  before :each do
    setup
  end

  context "GENERIC - " do
    it 'soft deletes the record' do
      product_id = @product.id
      @product.destroy
      expect(Product.unscoped.find(product_id)).to eql(@product)
    end
  end

  context "HOOKS -" do
    #No tests
  end

  context "VALIDATIONS -" do
    it 'valid product shouldn\'t raise any errors' do
      expect{create(:product)}.not_to raise_error
    end
    it 'validates_uniqueness_of name' do
      expect{create(:product, name: @product.name)}.to raise_error
    end
    it 'requires base_price to be equal or greater than 0' do
      expect{create(:product, base_price: -1)}.to raise_error
    end
    it 'requires an included product_type' do
      expect{create(:product, product_type: "invalid_product_type")}.to raise_error
    end
  end

  context "SCOPES -" do
    it 'game_maker scope works as expected' do
      3.times do 
        create(:product, product_type: Product::PRODUCT_TYPE_GAME_MAKER)
      end
      expect(Product.unscoped.where(deleted: false, product_type: Product::PRODUCT_TYPE_GAME_MAKER).pluck(:id).sort).to eql(Product.game_maker.pluck(:id).sort)
    end
  end

  context "METHODS -" do
    #No Tests
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
