Rails.application.routes.draw do
  resources :users, only: :show

  root to: 'users#show', defaults: { id: ENV['DEFAULT_USER_ID'] }
end
