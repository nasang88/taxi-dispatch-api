Rails.application.routes.draw do
  resources :dispatches do
    collection do
      get :show_dispatch_request, path: 'request'
      get :show_dispatch_accept, path: 'accept'
      post :create_dispatch, path: '/'
      post :accept_dispatch, path: ':id/accept'
      post :cancel_dispatch, path: ':id/cancel'
      delete :delete_dispatch, path: ':id'
    end
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
