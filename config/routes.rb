MorseSearchable::Engine.routes.draw do
  concern :searchable do
    collection do
      get :feed
      get :filters
    end
  end
  if Rails.env.test? 
    resources :fakes, concerns: :searchable
  end

end
