require 'json'
require 'spec_helper'
require 'api_spec_helper'

describe Api::V1::SubProductsController do
  before :each do
    setup
    additional_setup
  end

  describe "GET 'index'" do
    it "returns http error if no account provided" do
      get 'index'
      expect(response.status).to eql(401)
    end
    it "returns http success if account provided" do
      get 'index', key: @master_key
      expect(response.status).to eql(200)
    end
    it 'should return sub products for current account' do
      get 'index', key: @master_key
      sub_product_ids = JSON.parse(response.body).map{|sub_product|sub_product['id']}.sort
      expect(sub_product_ids).to eql(@master_user.sub_products.map{|sub_product|sub_product.id}.sort)
    end
  end

  describe "GET 'show'" do
    it "returns http error if no account provided" do
      get 'show', id: @sub_product.id
      expect(response.status).to eql(401)
    end
    it "returns http success if account provided" do
      get 'show', key: @master_key, id: @sub_product.id
      expect(response.status).to eql(200)
    end
    it "returns information for sub product with provided ID" do
      get 'show', key: @master_key, id: @sub_product.id
      sub_product = JSON.parse(response.body)
      #ensure sub_products are the same
      expect(sub_product['id']).to eql(@sub_product.id)
      expect(sub_product['base_price']).to eql(@sub_product.base_price)
      expect(sub_product['name']).to eql(@sub_product.name)
      expect(sub_product['sub_product_type']).to eql(@sub_product.sub_product_type)
    end
    it "returns error if no sub product matches provided ID" do
      get 'show', key: @master_key, id: 'invalid_id'
      expect(response.status).to eql(401)    
    end
  end

  def additional_setup
    @master_key = @master_user.parent_licence.key.to_s
    @sub_product = @master_user.sub_products.first
  end
end