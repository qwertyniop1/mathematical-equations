Rails.application.routes.draw do
  root 'static#home'

  get 'about', to: 'static#about'
  get 'api', to: 'static#api'
end
