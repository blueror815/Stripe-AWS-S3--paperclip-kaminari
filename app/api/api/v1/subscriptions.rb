module API
  module V1
    class Subscriptions < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource :subscriptions do

        # desc 'Return all Subscriptions.'
        # paginate max_per_page: 100
        # get do
        #   authenticate!
        #   paginate(Subscription.find_by_user_id(current_user.id).extend(SubscriptionRepresenter.for_collection))
        # end

        # desc 'Return a Subscription.'
        # params do
        #   requires :id, type: Integer, desc: 'Subscription id.'
        # end
        # route_param :id do
        #   get do
        #     authenticate!
        #     current_user.subscriptions.find(params[:id]).extend(SubscriptionRepresenter)
        #   end
        # end
        desc 'Return the latest Subscription'
        params do
          requires :user_id, type: Integer, desc: 'User ID for identify subscription.'
        end
        get do
          authenticate!
          current_user.subscriptions.order("created_at").last.extend(SubscriptionRepresenter)
        end

        desc 'Create a Subscription.'
        params do
          requires :user_id, type: Integer, desc: 'User ID for identify subscription.'
          requires :stripe_customer_id, type: String, desc: 'Customer ID.'
          requires :stripe_subscription_id, type: String, desc: 'Subscription ID.'
          requires :amount, type: Float, desc: 'Amount of charge.'
          requires :date, type: Date, desc: 'plans created date from Stripe.'
        end
        post do
          begin
            authenticate!
            subscription = current_user.subscriptions.create({user_id: params[:user_id],
                                                stripe_customer_id: params[:stripe_customer_id],
                                                stripe_subscription_id: params[:stripe_subscription_id],
                                                amount: params[:amount],
                                                date: params[:date]})
            subscription.save
            subscription.extend(SubscriptionRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        desc 'Update a Subscription'
        params do
          requires :id, type: Integer, desc: 'SubscriptionId for identifying the subscription'
          requires :cancelled_at, type: Date, desc: 'Cancelled Date for subscription'  
        end
        put ':id' do
          begin
            authenticate!
            subscription = current_user.subscriptions.find(params[:id])
            subscription.update(:cancelled_at => params[:cancelled_at])
            subscription.extend(SubscriptionRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        # desc 'Update a Subscription.'
        # params do
        #   requires :stripe_customer_id, type: String, desc: 'Stripe Customer ID'
        #   requires :stripe_subscription_id, type: String, desc: 'Stripe Subscription ID'
        #   requires :amount, type: Float, desc: 'Amount of charge.'
        # end
        # put do
        #   begin
        #     authenticate!
        #     subscription = current_user.subscriptions.find_by_stripe_customer_id(params[:stripe_customer_id])
        #     puts("subscription=========", subscription);
        #     attributesHash = {amount: params[:amount], stripe_subscription_id: params[:stripe_subscription_id]}
        #     subscription.update(attributesHash)
        #     subscription.extend(SubscriptionRepresenter)
        #   rescue Exception => e
        #     Raygun.track_exception(e)
        #   end
        # end

        # desc 'Delete a Subscription.'
        # params do
        #   requires :id, type: Integer, desc: 'Subscription ID.'
        # end
        # delete ':id' do
        #   status 204
        #   authenticate!
        #   Subscription.find(params[:user_id]).destroy.extend(SubscriptionRepresenter)
        # end
      end
    end
  end
end
