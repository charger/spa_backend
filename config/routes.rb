Rails.application.routes.draw do
  namespace :api do
    resources :posts
    post '/sign_in' => 'session#create'
  end
end
