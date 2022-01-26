class QueryController < ApplicationController

  # When a query is made to this API a new query object is created   #
  # to format request parameters. if parameters are not provided or  #
  # are invalid the appropriate error message is rendered.           #

  # If the query parameters are validated then a new JsonService is  #
  # created to help manage the results of the query. From there the  #
  # query is checked against the cache, if the query exists in cache #
  # it is returned, if not then the query is fetched.                #
  # FetchingService.rb && JsonService.rb are located in app/services #


  # GET /api/posts?queryString
  def posts
    @query = Query.new(request.params)

    # Check app/models/Query.rb's permitted attributes for param validation.
    if @query.validate_params

      # JsonService is used for storage, sorting, and merging of query results.
      @service = JsonService.new({
        request: @query.params,
        target: @query.target
      })
      cache_tags

      # if JsonService cant package results an internal error is rendered
      if @service.package
        render :json => @service.json, status: :ok
      else
        render :json => { error: 'internal server error' }, status: :internal_server_error
      end

    else
      render :json => @query.error, status: :bad_request
    end
  end

  private

  # The results of each query is saved in cache by name:              #
  # The results of a query for posts with the tag of ‘health’ will    #
  # be cached as "health_posts", this allows for expansion into other #
  # topics of query. For example: "tech_blogs"                        #

  # -Parts of this funtion would be better off in FetchingService-
  def cache_tags
    @query.params[:tags].split(',').each do |t|
      # change time on the line below to increase or decrease cache expiration
      data = Rails.cache.fetch("#{t}_#{@query.target}", expires_in: 5.minutes) {
        req = FetchingService.new({
          :target => @query.target,
          :query => { tag: t }
          })
        req.fetch
      }

      @service.storage.push(data)
    end
  end
end
