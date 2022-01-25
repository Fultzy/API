require 'rails_helper'

RSpec.describe JsonService do
  before(:all) do
    @valid_params = {
      request: {
        tags: 'apple,banana,orange,pineapple,peach,plum',
        sortBy: 'sugarContent',
        direction: 'desc'
      },
      target: 'fruit'
    }
    @service = JsonService.new(@valid_params)
  end


  describe 'when created' do
    it '@target value needs to be an object' do
      expect(@service.target).to be_a(Object)
    end

    it '@request value needs to remains a hash' do
      expect(@service.request).to be_a(Hash)
    end
  end


  describe '#merge_jsons' do
    it 'empty hash in @storage is returned to @json for render' do
      @service.storage.push({ fruit:[] })

      @service.merge_jsons
      expect(@service.json).to eq({ fruit:[] })
    end

    it 'merges an array of hashes into a single hash @json' do
      @service.storage.push({ :fruit => [
        { kind:'apple', sugarContent:19, size:4 },
        { kind:'orange', sugarContent:9, size:5 }
        ]})
      @service.storage.push({ :fruit => [
        { kind:'banana', sugarContent:14, size:7 },
        { kind:'pineapple', sugarContent:86, size:6 }
        ]})

      @service.merge_jsons
      expect(@service.json[:fruit].count).to eq(4)
    end

    it 'can merge more hashes if added after original merge to @json' do
      @service.storage.push({ :fruit => [
        { kind:'plum', sugarContent:7, size:2 },
        { kind:'peach', sugarContent:13, size:3 }
        ]})
        @service.merge_jsons
      expect(@service.json[:fruit].count).to eq(6)
    end
  end


  describe '#sortBy' do
    it 'sorts an array of hashes inside @json' do
      # @valid_params causes sort on sugarContent, descended
      @service.sortBy
      expect(@service.json).to eq(
        { :fruit => [
          { kind:'pineapple', sugarContent:86, size:6 },
          { kind:'apple', sugarContent:19, size:4 },
          { kind:'banana', sugarContent:14, size:7 },
          { kind:'peach', sugarContent:13, size:3 },
          { kind:'orange', sugarContent:9, size:5 },
          { kind:'plum', sugarContent:7, size:2 }
        ]})
    end

    it 'can re-sort elements in @json with new params' do
      @service.request[:sortBy] = 'size'
      @service.request[:direction] = 'asc'
      @service.sortBy

      expect(@service.json).to eq(
        { :fruit => [
          { kind:'plum', sugarContent:7, size:2 },
          { kind:'peach', sugarContent:13, size:3 },
          { kind:'apple', sugarContent:19, size:4 },
          { kind:'orange', sugarContent:9, size:5 },
          { kind:'pineapple', sugarContent:86, size:6 },
          { kind:'banana', sugarContent:14, size:7 }
        ]})
    end
  end


  describe '#package' do


    it 'clears the storage array after 1st package' do
      @service.package
      expect(@service.storage.count).to eq(0)
    end

    it 'empty hash is included with "non-empties" returns single hash' do
      @service.json = {}
      @service.storage = [{ fruit:[] }, { fruit:[
        { kind:'peach', sugarContent:13, size:3 },
        { kind:'apple', sugarContent:19, size:4 },
        { kind:'orange', sugarContent:9, size:5 }
      ]}]

      @service.package
      expect(@service.json).to eq({ fruit:[
        { kind:'peach', sugarContent:13, size:3 },
        { kind:'apple', sugarContent:19, size:4 },
        { kind:'orange', sugarContent:9, size:5 }
      ]})
    end

    it 'clears the storage array after 2nd package' do
      expect(@service.storage.count).to eq(0)
    end
  end

end
