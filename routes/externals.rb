module NanoTwitter
  module Routes
    module ExternalServices

      def self.registered(app)

        # For loader.io verification
        app.get '/loaderio-82d98309070f9f1c9315ff5dcd667982/' do
          'loaderio-82d98309070f9f1c9315ff5dcd667982'
        end

        #To reset/flush redis cloud database
        app.get '/redis/reset' do
          $redis.flushall
          success "All Redis Caches Cleared"
        end

      end
    end
  end
end


