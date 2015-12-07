module NanoTwitter
  module Rest
    module V1
      module UsersUpdate

        def self.registered(app)

          filter_userinfo = lambda do |info|
            (info.keys - User.accessible_attribs).each { |key| info.delete(key) }
            info
          end

          app.post '/api/v1/users' do
            parameter_error unless (User.accessible_attribs - params.keys).empty?
            user = User.new(filter_userinfo[params].merge({password: 'deis'}))
            user.save ? user.to_json : internal_error
          end

          app.put '/api/v1/users' do
            parameter_error unless params['id']
            not_allowed_error(
                'Changing password over REST API').to_json if params['password']
            user = User.find_by_id(params['id'])
            user.update_attributes(filter_userinfo[params])
            user.save ? user.to_json : internal_error
          end

        end
      end
    end
  end
end
