Rails.application.routes.draw do
  root to: "pages#home"
  
  get 'select_user', to: 'users#select', as: :select_user
  post 'set_user', to: 'users#set', as: :set_user

  get 'admin', to: 'admin#index', as: :admin
  post 'admin/bulk_level_up', to: 'admin#bulk_level_up', as: :bulk_level_up_admin

  resources :users, except: [:show] do
    member do
      post :level_up
    end
  end
  resources :development_times do
    collection do
      post :start_development
      post :end_development
    end
  end
  resources :achievements
  resources :mentor_avatars do
    collection do
      post :level_up
    end
  end
  resources :level_up_settings do
    member do
      patch :toggle_enabled
    end
  end

  resource :nullpo_game, only: [:show] do
    member do
      post :click
      post :reset
      get :status
    end
  end

  get "pages/home"
  namespace :api do
    namespace :v1 do
      resources :development_times, only: [:index, :create]
      resources :achievements, only: [:index, :create]
      resources :mentor_avatars, only: [:show]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  resources :members
  resources :work_logs do
    collection do
      post :start_work
      post :end_work
    end
  end

  get 'mentor_avatars/current', to: 'mentor_avatars#current', as: :current_mentor_avatar
end
