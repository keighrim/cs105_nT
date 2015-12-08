module NanoTwitter
  module Helpers
    module Session

      def login(user)
        session[:logged_in_user_id] = user.id
        session[:logged_in_user_name] = user.name
      end

      def logout
        session[:logged_in_user_id] = nil
        session[:logged_in_user_name] = nil
      end

      def logged_in_user
        User.find_by_id(session[:logged_in_user_id])
      end

    end
  end
end
