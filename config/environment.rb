# Load the Rails application.
require_relative "application"
config.action_mailer.delivery_method = :letter_opener_web
config.action_mailer.perform_deliveries = true
# Initialize the Rails application.
Rails.application.initialize!
