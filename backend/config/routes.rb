Rails.application.routes.draw do
  resources :respostas
  resources :formularios
  resources :students
  resources :turmas
  resources :questaos
  resources :templates
  resources :users
  
  get "up" => "rails/health#show", as: :rails_health_check

  post '/login', to: 'sessions#create'
  
  namespace :admin do
    post 'importar', to: 'importar#create'
  end
end