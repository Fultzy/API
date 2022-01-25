require 'rails_helper'

RSpec.describe "Bad Posts Queries::", type: :request do

  describe "GET /posts" do
    # TAGS ARE REQUIRED to exist
    it "triggers an error message for missing, required, parameters" do
      get '/api/posts'
      expect(JSON.parse(response.body)).to eq({"error"=>"tags parameter is required"})
    end
    # TAGS ARE REQUIRED to not be empty
    it "triggers an error message for empty, required, parameters" do
      get '/api/posts?tags='
      expect(JSON.parse(response.body)).to eq({"error"=>"tags parameter is required"})
    end
    # SORTBY parameter must be valid
    it "triggers an error message for invalid sortBy parameters" do
      get '/api/posts?tags=apple,banana,orange&sortBy=sugarContent'
      expect(JSON.parse(response.body)).to eq({"error"=>"sortBy parameter is invalid"})
    end
    # DIRECTION parameter must be valid
    it "triggers an error message for invalid direction parameters" do
      get '/api/posts?tags=apple,banana,orange&direction=upSideDown'
      expect(JSON.parse(response.body)).to eq({"error"=>"direction parameter is invalid"})
    end

  end
end
