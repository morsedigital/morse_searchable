Rails.application.routes.draw do
  concern :searchable do
    collection do
      get :feed
      get :filters
    end
  end
end
