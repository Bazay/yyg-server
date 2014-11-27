require 'spec_helper'

describe SubProduct do
  before :each do
    setup
  end

  context "GENERIC - " do
    it 'soft deletes the record'
  end

  context "HOOKS - " do
  end

  context "VALIDATIONS - " do
    it 'validates_uniqueness_of name'
    it 'requires base_price to be equal or greater than 0'
    it 'requires an included sub_product_type'
  end

  context "SCOPES - " do
    it 'export scope works as expected'
    it 'compiler scope works as expected'
  end

  context "METHODS - " do
  end

  #TEST METHODS
  def setup
  end
end
