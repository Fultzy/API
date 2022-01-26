
#### Json Fetching, Storing & Manipulation ####
class JsonService
  attr_accessor :storage, :json, :target, :request

  def initialize(params)
    @request = params[:request]
    @target = params[:target].to_sym
    @storage = []
    @json = {}
  end


  def package
    merge_jsons
    sortBy
    @storage = []
  end


  def sortBy     # sorts and or flips array inside hash
    unless @json.empty?
      @json[@target].sort_by! { |elm| elm[@request[:sortBy]] }
      @request[:direction] == 'desc' ? @json[@target].reverse! : @json
      return @json
    end
  end


  def merge_jsons               # merges an array of parced Json objects
    @storage.each do |json|     # with nested hashes into a new hash &&
      json.each do |key, array| # removes duplicates, handles empty arrays.
        key = key.to_sym        # String keys are also turned into symbols

        if array.empty? && @json[key].nil?
          @json[key] = []
        else
          array.each { |hash| @json[key].nil? ? @json[key] = [hash] : @json[key].push(hash) }
          @json[key].uniq!
        end

      end
    end
  end

end
