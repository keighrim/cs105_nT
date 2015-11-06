
module NanoTwitter
  module Test
    module Reset

      def self.registered(app)

        app.get '/test/reset' do
          session[:logged_in_user_id] = nil
          session[:logged_in_user_name] = nil
          User.where(name: 'testuser').destroy_all
          User.new(name: 'testuser', email: 'test@u.ser', password: 'test').save
          redirect '/'
        end
      end
    end
  end
end



