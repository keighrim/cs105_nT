module NanoTwitter
  module Helpers
    module Errors

      def parameter_error
        halt 400, 'Insufficient parameters'.to_json
      end

      def user_not_found_error(username)
        halt 400, "User not found: #{username}".to_json
      end

      def follow_loop_error
        halt 500, 'Cannot follow yourself'.to_json
      end

      def internal_error
        halt 500, 'Sorry, there was an error!'.to_json
      end

      def unauthorized_error
        halt 401.1, 'Invalid login credentials'
      end

      def not_allowed_error(action)
        halt 405, "Not allowed: #{action}".to_json
      end

    end
  end
end
