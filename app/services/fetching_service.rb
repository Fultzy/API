
#### URL handling ####
class FetchingService
  require 'net/http'
  attr_reader :uri, :target, :query

  # A new fetching service will yield a persistent URI object:  #
  # the Uri.query can be changed to allow multiple requests     #
  # from a single instance. if the path is required to change;  #
  # a new URI object will be required, so a new FetchingService #
  # is needed.
  def initialize(params)
    @target = params[:target].to_sym # action symbol
    @query = params[:query]   # query string
    @uri = path(@target)
  end


  def fetch
    @uri.query = URI.encode_www_form(@query)
    Rails.logger.info "FETCHING::#{@uri.query}"
    res = Net::HTTP.get_response(@uri)
    JSON.parse(res.body)
  end

  private

  def path(obj) # returns uri depending on requested object
    case obj
    when :posts then URI('https://api.hatchways.io/assessment/blog/posts')
    end
  end
end
