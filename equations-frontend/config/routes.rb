Rails.application.routes.draw do
  root 'static#home'

  get 'about', to: 'static#about', as: :about
  get 'developers', to: 'static#api', as: :api

  scope 'equations', controller: :equations do
    get 'linear', as: :linear
    get 'quadratic', as: :quadratic
  end
end
