# -*- encoding : utf-8 -*-
module ModyoHelper

  # Modyo methods

  def link_to_modyo_profile(user, options = {})

    link_to (options[:text] || user.name), modyo_profile_path(user), :class => 'parent'
  end

  def modyo_profile_path(user)
    "/#{modyo_site_key}/admin/people/members/show?membership_id=#{user.modyo_id}"
  end


  # Parameters

  def modyo_site_key
    MODYO['site_key']
  end

  def modyo_site_url
    MODYO['site_url']
  end

  def modyo_account_url
    MODYO['account_url']
  end

  def modyo_account_host
    MODYO['account_host']
  end

end
