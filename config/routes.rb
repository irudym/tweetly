Rails.application.routes.draw do

  devise_for :users
  root 'subscriptions#new'

  post 'subscriptions/search'
  put 'subscriptions/subscribe'
  get 'subscriptions/logout'
  resources :subscriptions


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
