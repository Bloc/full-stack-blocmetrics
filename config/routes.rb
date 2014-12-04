Rails.application.routes.draw do



  devise_for :users

  authenticated :user do
    root :to => "dashboards#show", as: :logged_in_root
  end

  resource :dashboard do
    resources :domains, except: [:index] do
      resources :verifications, only: [:create]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :events, only: [:create]
      match 'events.json' => "events#create", via: :options, as: :events_options
    end
  end

  root to: "home#index"
end
