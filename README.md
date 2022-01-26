# Mini-API
 #### A fetching and caching API implementation. Built for [Kolide](https://www.kolide.com/home)
This API was created to gather and sort the results from another API, particularly posts. Ideas for expansion into other topics was constantly in thought when creating this API; from how cache is saved to how things are fetched.

#### Thank You
Firstly, I'd like to thank you for the opportunity to receive this assignment. I've learned a lot about Rails that I didn't know before. The first application I wrote for this assignment was entirely off base and that wasted about 6 days before I realized my mistake. I had to start over but almost finished within the few remaining days left.

I saw the time extension button and was curious so I clicked it.. Hatchways instantly gave me another 10 days! I was not expecting that! So, since I received so much more time, I've been refactoring and improving my application; using this time to write the highest quality code I know how.

If you have any suggestions or topics that may have been overlooked in this application, please let me know. Your feed-back would be highly appreciated and would only help improve my skills as a developer. Thank you!

#### Assignment Notes:
Note for Query Model:
If this seems like I'm rebuilding rail's StrongParams it's b/c I am. I was having issues with the ActionController::Parameters and understanding how to validate & default query_string params with that structure. Since we're not using a database in this application, I did this in the model.

Note for Query Controller:
The cache_tags function is in the wrong place. I understand there's an amount of logic happening inside the controller and this isn't a great idea to do, but it was a quick implementation of caching. If I had more time to focus on this I would move it into FetchingService, instead testing was a larger priority then refactoring this function.

## Installation
Clone this depository with `$ git clone git@github.com:Fultzy/API.git` ( private directory )

From root directory run `$ bundle install `

## Usage
To run in development: `$ rails start`
To run in production: `$ rails start -e production`

### Dependencies:
Ruby: v3.0.1
Rails: v6.1.4

#### Production Dependencies:
  - sqlite3 ~> 1.4
  - puma ~> 5.0

#### Dev/Testing Dependencies:
  - Better_Errors ~> 2.9
  - Rspec-rails ~> 5.0

## Configuration
#### Cache Config
Caching of query results is done in the QueryController using Rails's built in cache. Within the `cache_tags` function the expiration time is set to 5 minutes. This amount of time can be increased or decreased depending on requirement. See line 51 in `app/controllers/query_controller.rb`:
```rb
data = Rails.cache.fetch("#{t}_#{@query.target}", expires_in: 5.minutes) {
```

The results of each query is saved in cache by name. The results of a query for posts with the tag of 'health' will be cached as `"health_posts"`, this allows for expansion into other topics of query. If the API was expanded to query blogs by tag for example: The results of a query for blogs with the tag of 'startups' can be cached as `"startups_blogs"`,  

#### Allowing Query Parameters
  Query parameters are required to be verified against a `permitted` hash: in this hash, as an example:
```rb
  { :posts => {
        :tags => :required,

        :direction => { :default => 'asc',
          :valid => ['asc', 'desc'] },

        :sortBy => { :default => 'id',
          :valid => ['id', 'reads', 'likes', 'popularity'] }
      }
    }
```
a `:valid` query for `:posts` requires at least one `:tag` parameter. subsequent allowed parameters have a `:default` value and an array of `:valid` values. this hash can be added to to include other query topics such as `:users`, `:blogs` or `:comments`.

## Testing
End-to-end testings was used to verify not only the query controller, but also the routes.

Testing is done with RSpec, simply run `$ bundle exec rspec`
Testing includes Services

## Services
### JsonService is used for:
- Temporary storage of query results
- Merging results from multiple fetch request
- Sorting results according to `sortBy` and `direction` params
- Packaging; clears storage to reduce runtime memory usage

### FetchingService is used for:
- Handling fetch request to other APIs
- Creates URI for fetch depending on request params
- Making multiple query requests to the same host

Note: does not make parallel requests

## Deployment
Depending on your method for deploying this application instructions may vary greatly.
Please follow instructions pertaining to your choice of deployment host.

## Related Documentation
- [Ruby 3.0.1 Core Documentation](https://ruby-doc.org/core-3.0.1/)
- [Ruby on Rails 6.1 Documentation](https://guides.rubyonrails.org/6_1_release_notes.html)
- [RSpec for Rails 5.0 Documentation](https://relishapp.com/rspec/rspec-rails/v/5-0/docs)
