Rails.application.routes.draw do
  resources :dispatches do
  end

  post 'auth/login', to: 'authentication#authenticate'
end
