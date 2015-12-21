module API
  module V1
    class PromoCodes < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource :pcodes do

        # http://localhost:3001/api/v1/pcodes/find?code=asdf1234
        desc 'Find a PromoCode by code.'
        params do
          requires :code, type: String, desc: 'PromoCode unique code.'
        end
        get 'find' do
          begin
            PromoCode.find_by_code(params[:code]).extend(PromoCodeRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        # http://localhost:3001/api/v1/pcodes?token=c458d9f942c337c5cc80551b52d215ac
        desc 'Return all Items.'
        paginate max_per_page: 100
        get do
          authenticate_uber_admin!
          paginate(PromoCode.all().extend(PromoCodeRepresenter.for_collection))
        end

        # http://localhost:3001/api/v1/pcodes/1?token=c458d9f942c337c5cc80551b52d215ac
        desc 'Return a PromoCode.'
        params do
          requires :id, type: Integer, desc: 'PromoCode id.'
        end
        route_param :id do
          get do
            begin
              authenticate_uber_admin!
              PromoCode.find(params[:id]).extend(PromoCodeRepresenter)
            rescue Exception => e
              Raygun.track_exception(e)
            end
          end
        end

        # curl -X POST -H 'Content-Type: application/json' -d '{"code": "askjhdiohwdkkdsh", "duration": 40, "expiration": "2015-12-20T23:35:19.703Z"}' http://localhost:3001/api/v1/pcodes?token=c458d9f942c337c5cc80551b52d215ac
        desc 'Create a PromoCode.'
        params do
          requires :code, type: String, desc: 'The PromoCode\'s unique code.'
          requires :duration, type: Integer, desc: 'Number of days to extend a free trial.'
          requires :expiration, type: DateTime, desc: 'PromoCode expiration date.'
          optional :description, type: String, desc: 'Description of the PromoCode.'
        end
        post do
          begin
            code_params = {
                code: params[:code],
                duration: params[:duration],
                expiration: params[:expiration]
            }
            code_params[:description] = params[:description] if params[:description]
            code = PromoCode.create(code_params)
            code.extend(PromoCodeRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        # curl -X PUT -H 'Content-Type: application/json' -d '{"duration": 50, "expiration": "2015-12-30T23:35:19.703Z"}' http://localhost:3001/api/v1/pcodes/1?token=c458d9f942c337c5cc80551b52d215ac
        desc 'Update a PromoCode.'
        params do
          requires :id, type: Integer, desc: 'PromoCode ID.'
          optional :code, type: String, desc: 'The PromoCode\'s unique code.'
          optional :duration, type: String, desc: 'Number of days to extend a free trial.'
          optional :expiration, type: DateTime, desc: 'PromoCode expiration date.'
          optional :description, type: String, desc: 'Description of the PromoCode.'
        end
        put ':id' do
          begin
            authenticate_uber_admin!
            code_params = {}
            code_params[:code] = params[:code] if params[:code]
            code_params[:duration] = params[:duration] if params[:duration]
            code_params[:expiration] = params[:expiration] if params[:expiration]
            code_params[:description] = params[:description] if params[:description]
            code = PromoCode.find(params[:id])
            code.update(code_params)
            code.extend(PromoCodeRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

        # curl -X DELETE http://localhost:3001/api/v1/pcodes/1?token=c458d9f942c337c5cc80551b52d215ac
        desc 'Delete a PromoCode.'
        params do
          requires :id, type: Integer, desc: 'PromoCode ID.'
        end
        delete ':id' do
          begin
            authenticate_uber_admin!
            status 204
            code = PromoCode.find(params[:id])
            code.destroy.extend(PromoCodeRepresenter)
          rescue Exception => e
            Raygun.track_exception(e)
          end
        end

      end
    end
  end
end