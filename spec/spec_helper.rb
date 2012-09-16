require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  ENV["RAILS_ENV"] ||= 'test'

  if ENV["COVERAGE"]
    require 'simplecov'
    SimpleCov.start 'rails' do
      minimum_coverage 90
      maximum_coverage_drop 3

      add_group "Long files" do |src_file|
        src_file.lines.count > 100
      end
    end
  end

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'factory_girl'
  require 'paperclip/matchers'
  require 'cancan/matchers'
  require 'casclient/frameworks/rails/filter'

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.include Paperclip::Shoulda::Matchers
    config.include Devise::TestHelpers, type: :controller

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/test/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = 'random'

    config.before(:each) do
      # reset PaperTrail so data from one test doesn't spill over another
      PaperTrail.controller_info = {}
      PaperTrail.whodunnit = nil
    end

    config.after(:suite) do
      warn I18n.missing_translations.join("\n") unless I18n.missing_translations.nil?
    end

    def file_from_assets(name)
      File.new(Rails.root.join('spec', 'assets', name))
    end
  end

  module I18n
    class << self
      attr_reader :missing_translations

      def missing_translation(*args)
        (@missing_translations ||= []) << args.first
      end
    end
  end

  I18n.exception_handler = :missing_translation

  Capybara.default_selector = :xpath
end

Spork.each_run do
  # This code will be run each time you run your specs.

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
end
