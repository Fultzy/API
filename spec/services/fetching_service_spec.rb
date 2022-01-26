require 'rails_helper'

RSpec.describe FetchingService do
  before(:all) do
    @service = FetchingService.new({
      target:'posts',
      query:{ kind: 'apple,banana,orange&sortBy=sugarContent' }
    })
  end


  describe 'on creation' do
    it '@target can be read & is an object' do
      expect(@service.target).to be_a(Object)
    end

    it '@query can be read & is a hash' do
      expect(@service.query).to be_a(Hash)
    end

    it 'creates a new URI object' do
      expect(@service.uri).to be_a(URI)
    end
  end


  describe 'the generated URI' do
    it 'points towards the targeted host' do
      expect(@service.uri.host).to eq('api.hatchways.io')
    end

    it 'points towards the targeted path' do
      expect(@service.uri.path).to eq('/assessment/blog/posts')
    end
  end


  describe '#fetch' do
    it 'attempts to fetch but returns an error response' do
      expect(@service.fetch).to eq({"error"=>"The tag parameter is required"})
    end
  end

end
