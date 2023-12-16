Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :accounts do
    resources :posts, only: [:create, :index] do
      resources :comments, only: [:create]
    end
  end

end
