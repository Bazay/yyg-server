require 'json'
require 'spec_helper'
require 'api_spec_helper'

describe Api::V1::ProductsController do
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
      get 'index', key: @standard_key
      expect(response.status).to eql(200)
    end
    it 'should return products for current account' do
      get 'index', key: @standard_key
      product_ids = JSON.parse(response.body).map{|product|product['id']}.sort
      expect(product_ids).to eql(@standard_user.products.map{|product|product.id}.sort)
    end
  end

  describe "GET 'show'" do
    it "returns http error if no account provided" do
      get 'show', id: @product.id
      expect(response.status).to eql(401)
    end
    it "returns http success if account provided" do
      get 'show', key: @standard_key, id: @product.id
      expect(response.status).to eql(200)
    end
    it "returns information for product with provided ID" do
      get 'show', key: @standard_key, id: @product.id
      product = JSON.parse(response.body)
      #ensure products are the same
      expect(product['id']).to eql(@product.id)
      expect(product['base_price']).to eql(@product.base_price)
      expect(product['name']).to eql(@product.name)
      expect(product['product_type']).to eql(@product.product_type)
    end
    it "returns error if no product matches provided ID" do
      get 'show', key: @standard_key, id: 'invalid_id'
      expect(response.status).to eql(401)    
    end
  end

  def additional_setup
    @standard_key = @standard_user.parent_licence.key.to_s
    @product = @standard_user.products.first
  end
end