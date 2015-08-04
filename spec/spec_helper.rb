ENV["RAILS_ENV"] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
require 'pry'


RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|

    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end
end

require 'shoulda/matchers'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

Dir[File.expand_path("../support/**/*.rb",__FILE__)].each {|f| require f}
class Thing
  def self.all
    []
  end

  def self.select(*)
    []
  end
end

class Sample < Thing
  attr_accessor :barcode
  def initialize 
    @barcode = "0000000000000"
  end
end
class ClothingType < Thing
  attr_accessor :title 
  def initialize
    @title = "anorak"
  end
end
class Color < Thing
  attr_accessor :title
  def initialize 
    @title = "blue"
  end
end

def new_sample
  Sample.new
end

def new_color
  Color.new
end