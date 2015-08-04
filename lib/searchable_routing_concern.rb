module SearchableConcern
  def self.included(base)
    base.instance_eval do
      concern :searchable do
        collection do
          get :feed
          get :filters
        end
      end
    end
  end
end