# Load the rails application
require File.expand_path('../application', __FILE__)
#
# Ruby > 1.9 needs explicit encoding declaration
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the rails application
SiteEtu::Application.initialize!

