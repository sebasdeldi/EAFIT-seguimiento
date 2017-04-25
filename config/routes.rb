Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  root 'dashboards#index'
  get "/user/:id", to: "dashboards#show", as: "user"
  resources :users, path: "user"
  get "/subjects/new", to: "subjects#new", as: "new_subject"
  post "/subjects/new", to: "subjects#create"
  get "subject/:id", to: "subjects#show", as: "subject"
  post "subject/:id", to: "subjects#show", as: "new_membership"
  get "subject/:id/panel", to: "subjects_panels#index", as: "subject_panel"
  get "/batch_load", to: "batch_loads#load_elements", as: "batch_load"
  post "/batch_load", to: "batch_loads#load_elements"

end
