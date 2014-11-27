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
  end
end
