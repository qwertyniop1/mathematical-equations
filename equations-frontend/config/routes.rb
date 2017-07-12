Rails.application.routes.draw do
  root 'static#home'

  get 'about', to: 'static#about', as: :about
  get 'developers', to: 'static#api', as: :api

  scope 'equations', controller: :equations do
    get 'linear', as: :linear
    post 'linear', as: :solve_linear, action: :solve_linear

    get 'quadratic', as: :quadratic
    post 'quadratic', as: :solve_quadratic, action: :solve_quadratic
  end
end
