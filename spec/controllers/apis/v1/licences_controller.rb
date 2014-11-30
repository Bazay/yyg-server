require 'spec_helper'
require 'api_spec_helper'

describe Api::V1::LicencesController do
  before :each do
    setup
  end

  describe "GET 'index'" do
    it "returns http error if no account provided" do
      get 'index'
      binding.pry
      response.should be_error
    end
    it "returns http success" do
      get 'index', id: @standard_licence.parent_licence.key.to_s
      response.should be_success
    end
    it 'should return licences for current account' do
    end
  end
end
