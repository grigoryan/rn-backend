Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :accounts do
    resources :posts, only: [:create, :index] do
      resources :comments, only: [:create]
    end
  end

  resources :posts do
    collection do
      get :index_with_last_two_comments
    end
  end


end
