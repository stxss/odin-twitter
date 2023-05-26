Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "tweets#index"

  # path "" -> removes the /users/ prefix from url, specifying username as the identifier instead of the default :id
  resources :users, path: "", param: :username, only: [:index, :new, :create, :edit, :update, :destroy] do
    member do
      get :following, :followers
    end
  end

  resources :tweets
  resources :follows, only: %i[create destroy]
  resources :notifications, only: %i[index]
  resources :accounts, path: "settings", only: %i[ index edit update ]

  get "/:username", to: "users#show", as: "username"

  # Edit profile display_name, bio, etc
  get "/settings/profile/", to: "users#edit", as: "settings"

  # General display of account settings
  get "/settings/account/", to: "accounts#index", as: "settings_account"

  # Your account section

  # Privacy and safety section
  get "/settings/privacy_and_safety/", to: "accounts#edit_privacy_and_safety", as: "settings_privacy"
  get "/settings/audience_and_tagging/", to: "accounts#edit_audience_and_tagging", as: "settings_audience_and_tagging"
  get "/settings/tagging/", to: "accounts#edit_tagging", as: "settings_tagging"

  get "/settings/your_tweets/", to: "accounts#edit_your_tweets", as: "settings_your_tweets"

  get "/settings/content_you_see/", to: "accounts#edit_content_you_see", as: "settings_content_you_see"

  get "/settings/mute_and_block/", to: "accounts#edit_mute_and_block", as: "settings_mute_and_block"
  get "/settings/blocked/all", to: "accounts#edit_blocked_all", as: "settings_blocked_all"
  get "/settings/blocked/imported", to: "accounts#edit_blocked_imported", as: "settings_blocked_imported"
  get "/settings/muted/all", to: "accounts#edit_muted_all", as: "settings_muted_all"
  get "/settings/muted_keywords", to: "accounts#edit_muted_keywords", as: "settings_muted_keywords"
  get "/settings/notifications/advanced_filters", to: "accounts#edit_notifications_advanced_filters", as: "settings_notifications_advanced_filters"

  get "/settings/direct_messages/", to: "accounts#edit_direct_messages", as: "settings_direct_messages"
  # get "/settings//", to: "accounts#edit_", as: "settings_"

  # get "/settings/account/", to: "", as: "settings"
  # get "/settings/notifications/", to: "", as: "settings_notifications"
  # get "/settings/security_and_account_access", to: "", as: "settings_security"
  # get "/settings/accessibility_display_and_languages", to: "", as: "settings_display"
end
