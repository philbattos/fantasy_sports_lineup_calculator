Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  get 'calculator' => 'calculations#show'
  post 'calculator' => 'calculations#show'
  resources :lineups

  resources :baseball

end
