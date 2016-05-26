require 'active_support/dependencies'
require 'modyo/engine'
require 'modyo/session'
require 'modyo/version'
require 'modyo/app'

module Modyo
  class Engine < ::Rails::Engine
    isolate_namespace Modyo

    initializer 'modyo.load_config' do |app|
      require 'oauth2'

      ::MODYO = {}

      # begin
      #   yaml_file = YAML.load_file("#{Rails.root}/config/modyo.yml")
      # rescue Exception => e
      #   raise StandardError, 'config/modyo.yml could not be loaded.'
      # end
      #
      # if yaml_file
      #   if yaml_file[Rails.env]
      #     MODYO.merge!(yaml_file[Rails.env])
      #   else
      #     raise StandardError, "config/modyo.yml exists, but doesn't have a configuration for RAILS_ENV=#{Rails.env}."
      #   end
      # else
      #   raise StandardError, 'config/modyo.yml does not exist.'
      # end
    end

    initializer 'modyo.load_app' do |app|
      Modyo.setup do |config|
        config.app_root = app.root
      end

      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    initializer 'modyo.load_extentions' do |app|
      ActiveSupport.on_load(:action_controller) do
        include Modyo::Session
      end
    end
  end
end
