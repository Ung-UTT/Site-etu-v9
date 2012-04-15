# Load the rails application
require File.expand_path('../application', __FILE__)

# FIXME: On force l'UTF-8 pour ruby 1.9.x
#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

# Initialize the rails application
SiteEtu::Application.initialize!
