# Load the rails application
require File.expand_path('../application', __FILE__)

# Set UTF-8 as default encoding
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the rails application
SiteEtu::Application.initialize!

