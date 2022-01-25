require 'rails_helper'

RSpec.describe FetchingService do
  before(:all) do
    @service = FetchingService.new({
      target:'test',
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
      expect(@service.uri.host).to eq('localhost')
    end

    it 'points towards the targeted path' do
      expect(@service.uri.path).to eq('/api/test')
    end
  end


  describe '#fetch' do
    it 'attempts to fetch from an internal url but fails' do
      expect { @service.fetch }.to raise_error{Errno::ECONNREFUSED}
    end

    xit "encodes a query string for this failed fetch's URI" do
      expect(@service.uri.query).to eq(
        'kind=apple,banana,orange&sortBy=sugarContent'
      )
    end
  end

end
