module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource :users do

        desc 'Return a User.'
        get 'me' do
          begin
            authenticate!
            current_user.extend(UserRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end

        # http://localhost:3001/api/v1/users/resetpass?email=testy@testy.com
        desc 'Reset a password by email.'
        params do
          requires :email, type: String, desc: 'Valid user email.'
        end
        get 'resetpass' do
          begin
            user = User.find_by_email(params[:email])
            if user 
              random_password = SecureRandom.hex(4)
              if user.update(password: random_password, password_confirmation: random_password)
                {new_pass: random_password}
              else
                error!('Error resetting password.', 500)
              end
            else
              error!('User not found.', 404)
            end
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end

        # http://localhost:3001/api/v1/users/subscribers?token=35dd596eea2b8eeb948c8ec9b56f2877&force=true
        desc 'Return all trial users - ONLY IF THE SIGNED IN USER IS AN UBER ADMIN.'
        paginate max_per_page: 100
        get 'all' do
          begin
            authenticate_uber_admin!
            users = User.all
            trial_users = Subscribers.new(num_trial: User.trial_users.count,
                                          num_full: User.subscribed_users.count,
                                          users: paginate(users))
            trial_users.extend(UsersRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end

        desc 'Return a User.'
        params do
          requires :id, type: Integer, desc: 'User id.'
        end
        route_param :id do
          get do
            begin
			        authenticate!
              error!('Unauthorized', 401) unless current_user.id == params[:id]
              User.find(params[:id]).extend(UserRepresenter)
			      rescue Exception => e
              Raygun.track_exception(e)
              error!(e.to_s, 500)
            end
          end
        end

        desc 'Create a User.'
        params do
          requires :email, type: String, desc: 'Email address.'
          requires :password, type: String, desc: 'Password.'
          requires :password_confirmation, type: String, desc: 'Password Confirmation.'
          optional :trial_began, type: DateTime, desc: 'Date the trial began.'
          optional :trial_ended, type: DateTime, desc: 'Date the trial ended.'
          optional :first_name, type: String, desc: 'Users first name.'
          optional :last_name, type: String, desc: 'Users last name.'
          optional :artist_name, type: String, desc: 'Users artist name.'
          optional :pcode_id, type: Integer, desc: 'PromoCode ID to be applied to the users trial.'
        end
        post do
          begin
            user_params = {
                email: params[:email],
                password: params[:password],
                password_confirmation: params[:password_confirmation]
            }
            user_params[:trial_began] = params[:trial_began] if params[:trial_began]
            user_params[:trial_ended] = params[:trial_ended] if params[:trial_ended]
            user_params[:first_name] = params[:first_name] if params[:first_name]
            user_params[:last_name] = params[:last_name] if params[:last_name]
            user_params[:artist_name] = params[:artist_name] if params[:artist_name]
            user = User.create(user_params)
            user.promo_code = PromoCode.find(params[:pcode_id]) if params[:pcode_id]
            user.save
            user.extend(UserRepresenter)
		      rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end

        desc 'Update a User.'
        params do
          requires :id, type: Integer, desc: 'User ID.'
          requires :email, type: String, desc: 'Email address.'
          optional :trial_began, type: DateTime, desc: 'Date the trial began.'
          optional :trial_ended, type: DateTime, desc: 'Date the trial ended.'
          optional :password, type: String, desc: 'Password.'
          optional :password_confirmation, type: String, desc: 'Password Confirmation.'
          optional :first_name, type: String, desc: 'Users first name.'
          optional :last_name, type: String, desc: 'Users last name.'
          optional :artist_name, type: String, desc: 'Users artist name.'
        end
        put ':id' do
          begin
            authenticate!
            error!('Unauthorized', 401) unless current_user.id == params[:id]
            user_params = {
                email: params[:email]
            }
            user_params[:trial_began] = params[:trial_began] if params[:trial_began]
            user_params[:trial_ended] = params[:trial_ended] if params[:trial_ended]
            user_params[:password] = params[:password] if params[:password]
            user_params[:password_confirmation] = params[:password_confirmation] if params[:password_confirmation]
            user_params[:first_name] = params[:first_name] if params[:first_name]
            user_params[:last_name] = params[:last_name] if params[:last_name]
            user_params[:artist_name] = params[:artist_name] if params[:artist_name]
            puts "Params Artist Name: #{params[:artist_name]}"
            puts "User Params Artist Name: #{user_params[:artist_name]}"
            current_user.update(user_params)
            current_user.extend(UserRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end
        
        # http://localhost:3001/api/v1/users/upgrade

        desc 'Upgrade Membership.'
        params do
          requires :id, type: Integer, desc: 'User ID.'
          requires :stripe_customer_id, type: String, desc: 'Customer ID.'
          requires :stripe_subscription_id, type: String, desc: 'Subscription ID.'
          requires :stripe_active_until, type: Date, desc: 'date that the current subscription is active until.'
          requires :trial_ended, type: Date, desc: 'date that the trial Membership is ended'          
        end
        put '/upgrade/:id' do
          begin
            authenticate!
            error!('Unauthorized', 401) unless current_user.id == params[:id]
            puts "User ID: #{params[:id]}"
            user_params = {
                email: params[:email]
            }
            user_params[:stripe_customer_id] = params[:stripe_customer_id]
            user_params[:stripe_subscription_id] = params[:stripe_subscription_id] 
            user_params[:stripe_active_until] = params[:stripe_active_until]
            user_params[:trial_ended] = params[:trial_ended]
            puts "Customer ID: #{params[:stripe_customer_id]}"
            current_user.update(user_params)
            current_user.extend(UserRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end

        desc 'Cancel Membership'
        params do
          requires :id, type: Integer, desc: 'User ID.'
          requires :trial_began, type: Date, desc: 'Date that user begins for free or cancel membership'
        end
        put '/cancel/:id' do
          begin
            authenticate!
            error!('Unauthorized', 401) unless current_user.id == params[:id]
            puts "User ID: #{params[:id]}"
            current_user.update(:stripe_subscription_id => nil, 
                                :stripe_active_until => nil, 
                                :trial_began => params[:trial_began],
                                :trial_ended => nil)
            current_user.extend(UserRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end


        desc 'Delete a User.'
        params do
          requires :id, type: Integer, desc: 'User ID.'
        end
        delete ':id' do
          begin
            status 204
            authenticate!
            error!('Unauthorized', 401) unless current_user.id == params[:id]
            current_user.destroy.extend(UserRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
            error!(e.to_s, 500)
          end
        end

      end
    end
  end
end
