Rails.application.routes.draw do

  resources :meals do
    member do
      match 'przylacz', to: 'meals#join', via: [:get, :post], as: :join
    end

    resources :meal_shares do
      collection do
        delete 'zrezygnuj', to: 'meal_shares#quit', as: :quit
      end
    end

  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get 'konto/wyloguj', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'dashboard', to: "account#dashboard", as: :dashboard
  get 'konto/edycja', to: "account#profile", as: :edit_profile
  put 'konto/', to: "account#update", as: :update_account
  get 'konto/posilki', to: "meals#mine", as: :my_meals


  get '/jak-to-dziala', to: "pages#about", as: 'about'
  get '/kontakt', to: "pages#contact", as: 'contact'


  root 'pages#landing'

end
