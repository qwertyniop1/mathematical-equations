Rails.application.routes.draw do
  root 'static#home'

  get 'about', to: 'static#about'
  get 'developers', to: 'static#api'
end
