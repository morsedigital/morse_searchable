require 'pry'

Rails.application.routes.draw do


  binding.pry


  resources :fakes, concerns: :searchable


end
