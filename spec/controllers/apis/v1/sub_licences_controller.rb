require 'json'
require 'spec_helper'
require 'api_spec_helper'

describe Api::V1::SubLicencesController do
  before :each do
    setup
  end

  describe "GET 'index'" do
    it "returns http error if no account provided" do
      get 'index'
      expect(response.status).to eql(401)
    end
    it "returns http success if account provided" do
      get 'index', key: @master_user.parent_licence.key.to_s
      expect(response.status).to eql(200)
    end
    it 'should return licences for current account' do
      get 'index', key: @master_user.parent_licence.key.to_s
      licence_ids = JSON.parse(response.body).map{|licence|licence['id']}.sort
      expect(licence_ids).to eql(@master_user.sub_licences.pluck(:id).sort)
    end
  end
end