Rails.application.routes.draw do

  mount GrapeSwaggerRails::Engine => '/swagger'
  mount API::Base, at: "/"

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
