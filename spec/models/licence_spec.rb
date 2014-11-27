require 'spec_helper'

describe Licence do
  before :each do
    setup
  end

  context "GENERIC - " do
    it 'soft deletes the record'
  end

  context "HOOKS - " do
    it 'generates a uniq, uuid-based key for the record on creation'
    it 'sets expires_at on creation'
  end

  context "VALIDATIONS - " do
    it 'validates_uniqueness_of key'
    it 'requires a key'
    it 'requires an included sub_product_type'
  end

  context "SCOPES - " do
    it 'parent_licences scope works as expected'
    it 'sub_licences scope works as expected'
    it 'product_licences scope works as expected'
    it 'sub_product_licences scope works as expected'
    it 'export_licences scope works as expected'
    it 'compiler_licences scope works as expected'
  end

  context "METHODS - " do
    it 'can be set to active'
    it 'can be set to revoked'
    it 'can be set to expired'
    it 'expiry date can be set by expiry_key'
  end

  context "OBSERVER - " do
    it 'correctly sets up sub_product licences after the creation of a product licence'
    it 'ensures duplicate sub_licences are not created'
  end

  #TEST METHODS
  def setup
  end
end
