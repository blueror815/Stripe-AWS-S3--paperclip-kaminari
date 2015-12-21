module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource :auth do

        desc 'Creates and returns a token if valid login'
        params do
          requires :login, type: String, desc: 'Username or email address'
          requires :password, type: String, desc: 'Password'
        end
        post :login do
          if params[:login].include?('@')
            user = User.find_by_email(params[:login])
          else
            user = User.find_by_username(params[:login])
          end

          if user && user.authenticate(params[:password])
            ApiKey.create(user_id: user.id).extend(ApiKeyRepresenter)
          else
            error!('Unauthorized.', 401)
          end
        end

        desc 'Ends a user session be destroying the associated token'
        params do
          requires :token, type: String, desc: 'Access token.'
        end
        delete do
          authenticate!
          @current_user.api_key.destroy
        end

        desc 'Returns pong if logged in correctly'
        params do
          requires :token, type: String, desc: 'Access token.'
        end
        get :ping do
          authenticate!
          { message: 'pong' }
        end

      end

    end
  end
end