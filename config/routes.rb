Rails.application.routes.draw do
  root 'home#index'
  get 'callback' => 'callback#index', defaults: {format: 'json'}
end
