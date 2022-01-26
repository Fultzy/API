class Query
  attr_reader :error, :target, :params

  def initialize(raw_params)
    @params = raw_params
    @target = raw_params[:action].to_sym
  end


    # Checking allowed_params for missing or invalid parameters: #
    # only accepting values of allowed parameters if they're in  #
    # the permitted hash. Since the decision to fetch depends on #
    # there not being errors in the query; this function returns #
    # a boolean after potentailly setting an error status.       #

# NOTE: if this seems like im rebuilding rail's StrongParams it's bc i am.
# I was having issues with the ActionController::Parameters and understanding
# how to validate & default query_string params with that structure. Since
# we're not using a database in this application, I did this in the model.
    def validate_params
      allowed_params

      # requiring params, applying default params, triggering errors: #
      permitted[@target].each do |param, accepted|
        if accepted == :required
          if @params[param].nil? || @params[param].empty?
            @error = { "error": "#{param} parameter is required" }
          end

        elsif @params[param].nil? || @params[param].empty?
          @params[param] = accepted[:default]

        elsif @params[param].present? && accepted != :required
          unless accepted[:valid].include?(@params[param])
            @error = { "error": "#{param} parameter is invalid" }
          end
        end

        # returns false if there are any errors:         #
        # if false is returned here the query#posts      #
        # method will stop to render the @error message. #
        unless @error.nil?
          return false
        end
      end
      true
    end


  private

  #### Request Params ####
  # Query params are required to be verified against this permitted hash: #
  # in this hash as an example: a valid query for :posts requires atleast #
  # one tag parameter. subsequent allowed params have a :default value    #
  # and an array of :valid values. this hash can be added to to include   #
  # other topics such as :users, :blogs or :comments                      #
  def permitted
    { :posts => {
        :tags => :required,

        :direction => { :default => 'asc',
          :valid => ['asc', 'desc'] },

        :sortBy => { :default => 'id',
          :valid => ['id', 'reads', 'likes', 'popularity'] }
      }
    }
  end


  def allowed_params               # Only allows permitted keys to be passed  #
    new_params = {}                # into a new instance of params. each key  #
    @params.each do |param, value| # becomes symbol but values remain strings #
      if permitted[@params[:action].to_sym].include?(param.to_sym)
        new_params[param.to_sym] = value
      end
    end
    @params = new_params
  end

end
