module Modyo
  module Authenticate

    module ClassMethods
      def authenticate_with_modyo
        if session[:user]
          true
        else
          session[:return_to] = request.url
          redirect_to '/modyo'
        end
      end
    end

    module InstanceMethods
      def authenticate_with_modyo
        if session[:user]
          true
        else
          session[:return_to] = request.url
          redirect_to '/modyo'
        end

      end


      # Helper methods

          helper_method :link_to_modyo_profile

          def link_to_modyo_profile(user, options = {})

            link_to (options[:text] || user.name), modyo_profile_path(user), :class => 'parent'
          end

          helper_method :modyo_profile_path

          def modyo_profile_path(user)
            "/#{modyo_site_key}/admin/people/members/show?membership_id=#{user.modyo_id}"
          end

          # Parameters

          helper_method :modyo_site_key

          def modyo_site_key
            MODYO['site_key']
          end


          helper_method :modyo_site_url

          def modyo_site_url
            MODYO['site_url']
          end


          helper_method :modyo_account_url

          def modyo_account_url
            MODYO['account_url']
          end


          helper_method :modyo_account_host

          def modyo_account_host
            MODYO['account_host']
          end


          helper_method :modyo_site_main_url

          def modyo_site_main_url
            "#{modyo_site_url}/apps/#{MODYO['canvas_namespace']}"
          end


          helper_method :modyo_site_me_url

          def modyo_site_me_url
            "#{modyo_site_url}/me/#{MODYO['canvas_namespace']}"
          end


          helper_method :modyo_admin_main_url

          def modyo_admin_main_url
            "#{modyo_account_url}/#{modyo_site_key}/admin/apps/#{MODYO['canvas_namespace']}"
          end

    end

  end
end
