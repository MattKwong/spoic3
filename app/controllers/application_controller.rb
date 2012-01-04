class ApplicationController < ActionController::Base
  protect_from_forgery

 def after_sign_in_path_for(resource)
 #this overrides the default method in the devise library

    if resource.liaison?
      liaison = Liaison.find_by_email1(resource.email)
      myssp_path(liaison.id)
    else
      '/'
    end

      #     stored_location_for(resource) ||
      #       if resource.is_a?(User) && resource.can_publish?
      #         publisher_url
      #       else
      #         signed_in_root_path(resource)
      #       end
      #
 end
end
