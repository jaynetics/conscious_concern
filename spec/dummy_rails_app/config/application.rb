require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'conscious_concern'

module DummyRailsApp
  class Application < Rails::Application
  end
end
