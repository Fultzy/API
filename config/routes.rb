Rails.application.routes.draw do
  get '/api/ping' => 'main#ping', :as => 'ping'
  get '/api/posts' => 'query#posts', :as => 'posts'
end
