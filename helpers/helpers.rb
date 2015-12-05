module NanoTwitter
  module Helpers

    def logged_in_user
      User.find_by_id(session[:logged_in_user_id])
    end

    def success(message)
      status 200
      body message
    end

  end
end
