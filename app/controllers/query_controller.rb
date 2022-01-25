class QueryController < ApplicationController

  def posts
    @query = Query.new(request.params)

    if @query.validate_params
      @service = JsonService.new({
        request: @query.params,
        target: @query.target
      })

      cache_tags

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

  #
  def cache_tags
    @query.params[:tags].split(',').each do |t|

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
