# frozen_string_literal: true

def enable_test_coverage
  require "simplecov"

  SimpleCov.start do
    add_filter "/test/"

    add_group "Models", "app/models"
    add_group "Controllers", "app/controllers"
    add_group "Services", "app/services"
    add_group "Mailers", "app/mailers"
  end
end

enable_test_coverage if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end
