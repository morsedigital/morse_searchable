require 'rails_helper'
require 'pry'
RSpec.describe "FakesController", type: :routing do

  describe "get /fakes/feed", type: :routing do
    it 'should be searchable' do
      expect(get: "/fakes/feed").to route_to(
        controller: "fakes", 
        action: 'feed',
      )
    end
  end
  describe "get /fakes/filters", type: :routing do
    it 'should be filterable' do
      expect(get: "/fakes/filters").to route_to(
        controller: "fakes", 
        action: 'filters',
      )
    end
  end
end