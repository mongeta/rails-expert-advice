Rails.application.routes.draw do
  use_doorkeeper

   namespace :api do
    namespace :v1 do
      get '/users/me', to: 'users#me'
      resources :users
      resources :posts, param: :slug
      resources :answers, param: :slug
      resources :tags, only: [:index, :show]
    end
  end
end
