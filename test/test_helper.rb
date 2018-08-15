# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../test/dummy/config/environment.rb", __dir__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

if ENV["CI"] == "true"
  require "simplecov"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov

  SimpleCov.start "rails" do
    add_filter "lib/action_store/version"
    add_filter "lib/generators"
  end
end

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

ExceptionTrack.configure do
  self.environments = %i[test production]

  self.basic_auth_enable = true
  self.basic_auth_name = "admin"
  self.basic_auth_password = "password"
end

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end
