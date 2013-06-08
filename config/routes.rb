Rubbit::Application.routes.draw do

  root to: 'static_pages#home'

  get '/about' => 'static_pages#about'

  # Standard posts.
  resources :posts, except: [:index, :destroy] do
    member do
      put :up, :down
    end

    collection do
      get :named
    end

    resources :posts, path: 'reply', only: [:new, :create], path_names: { new: '' }
  end

  devise_for :users #, param: 'username'
end
