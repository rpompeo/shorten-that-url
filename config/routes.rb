Rails.application.routes.draw do

  devise_for :admins
  root "pages#home"
  get 'urls/retrieve', to: 'urls#retrieve'
  post 'urls/retrieve', to: 'urls#retrieve_slug'
  resources :urls
  
  #devise_scope :admin do
  #  root :to => "devise/sessions#new"
  #end
  
  #root to: "admins#sign_in"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
