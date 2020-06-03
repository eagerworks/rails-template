Rails.application.routes.draw do
  devise_for :users

  get 'buttons', to: 'home#buttons'
  get 'cards', to: 'home#cards'
  get 'cards', to: 'home#cards'
  get 'charts', to: 'home#charts'
  get 'tables', to: 'home#tables'
  get 'utilities_animation', to: 'home#utilities_animation'
  get 'utilities_border', to: 'home#utilities_border'
  get 'utilities_color', to: 'home#utilities_color'
  get 'utilities_other', to: 'home#utilities_other'
  root to: 'home#index'
end
