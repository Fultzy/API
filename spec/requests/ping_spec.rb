require 'rails_helper'

RSpec.describe "Ping", type: :request do
  describe "GET /ping" do
    before(:all) do
      get '/api/ping'
    end

    it "returns the success response" do
      expect(response).to have_http_status(200)
    end

    it "returns the success response of 200" do
      expect(JSON.parse(response.body)).to eq({"success" => true})
    end
  end
end
