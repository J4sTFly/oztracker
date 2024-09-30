require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  mount Sidekiq::Web => "/sidekiq"

  concern :searchable do |options|
    post :search, to: "#{options[:on]}#index"
    get :search, to: "#{options[:on]}#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "category_links#new"

  resources :category_links, only: %i[index new create] do
    collection do
      concerns :searchable, on: "category_links"
    end
  end
end
