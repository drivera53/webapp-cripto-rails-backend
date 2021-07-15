Rails.application.routes.draw do
  resources :coins
  resources :trades
  resources :portfolios
  resources :users

  post '/login', to: "session#login"
  post '/signup', to: "users#create"
  get '/auto-login', to: "session#auto_login"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
