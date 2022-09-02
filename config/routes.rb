Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :companies, only: %i[index create destroy] do
        resources :groups, controller: 'companies/groups', only: %i[index create destroy]
        resources :users, controller: 'companies/users', only: :create
      end
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
