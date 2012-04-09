require "active_support/dependencies"

module Modyo

  # Our host application root path
  # We set this when the engine is initialized
  mattr_accessor :app_root

  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end

end

# Require our engine
require "modyo/engine"
require "modyo/mailer"
require "modyo/feed"
require "modyo/target"
require "modyo/session"
require "modyo/version"
