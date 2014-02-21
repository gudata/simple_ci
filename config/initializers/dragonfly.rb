require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "7d4eca7c2c91c66d1d9a7ee9e61dfe8579ec3295a1a8aa5c85bd2928c264133d"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
