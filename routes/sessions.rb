module NanoTwitter
  module Routes
    module Sessions

      def self.registered(app)


        app.post '/login' do
          name = params[:name]
          password = params[:password]
          u = User.find_by(name: name, password: password)
          unauthorized_error if u.nil?
          login(u)
          redirect '/'
        end

        app.get '/logout' do
          logout
          redirect '/'
        end

        app.get '/register' do
          output = partial( :navbar )
          output << partial( :register )
          output
        end

        app.post '/register' do
          new_user = User.new(params)
          new_user.save ? login(new_user) : internal_error
          redirect '/'
        end

      end
    end
  end
end


