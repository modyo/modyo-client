module Modyo
  class Engine < Rails::Engine

    initializer "modyo.load_config" do |app|

      ::MODYO = {}

      begin
        yaml_file = YAML.load_file("#{Rails.root}/config/modyo.yml")
      rescue Exception => e
        raise StandardError, "config/modyo.yml could not be loaded."
      end

      if yaml_file
        if yaml_file[Rails.env]
          MODYO.merge!(yaml_file[Rails.env])
        else
          raise StandardError, "config/modyo.yml exists, but doesn't have a configuration for RAILS_ENV=#{Rails.env}."
        end
      else
        raise StandardError, "config/modyo.yml does not exist."
      end

    end

    initializer "modyo.load_app_instance_data" do |app|
      Modyo.setup do |config|
        config.app_root = app.root
      end
    end

    initializer "modyo.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    initializer 'modyo.app_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        extend Modyo::Authenticate::ClassMethods
        include Modyo::Authenticate::InstanceMethods
      end
    end


  end

end