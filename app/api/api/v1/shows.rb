module API
  module V1
    class Shows < Grape::API
      include API::V1::Defaults
      helpers API::V1::SharedHelpers

      resource :shows do

        desc 'Return all Shows.'
        paginate max_per_page: 100
        get do
          authenticate!
          paginate(current_user.shows.order(date: :asc).extend(ShowRepresenter.for_collection))
        end

        desc 'Return a Show.'
        params do
          requires :id, type: Integer, desc: 'Show id.'
        end
        route_param :id do
          get do
            authenticate!
            current_user.shows.find(params[:id]).extend(ShowRepresenter)
          end
        end

        desc 'Create a Show.'
        params do
          requires :sync_uuid, type: String, desc: 'Unique ID used to identify the object within API clients.'
          requires :date, type: DateTime, desc: 'Date of show.'
          requires :active, type: Boolean, desc: 'Active flag.'
          requires :deleted_state, type: Boolean, default: false, desc: 'Deleted state.'
          requires :road_merch_only, type: Boolean, desc: 'Road merch only status'
          optional :venue_cut, type: Integer, desc: 'Venue cut'
          requires :venue, type: Hash do
            requires :name, type: String, desc: 'Venue Name'
            requires :zip, type: Integer, desc: 'Venue Zip'
            requires :state, type: String, desc: 'Venue State'
            requires :phone, type: String, desc: 'Venue Phone'
            requires :email, type: String, desc: 'Venue Email'
            requires :city, type: String, desc: 'Venue City'
            requires :address, type: String, desc: 'Venue Address'
            requires :contact, type: String, desc: 'Venue contact'
          end
        end
        post do
          authenticate!
          show_params = {
              date: params[:date],
              sync_uuid: params[:sync_uuid],
              active: params[:active],
              deleted_state: params[:deleted_state],
              road_merch_only: params[:road_merch_only]
          }
          show_params['venue_cut'] = params['venue_cut'] if params['venue_cut']
          show = current_user.shows.create(show_params)
          venue_params = params[:venue]
          if venue = Venue.find_by_name(venue_params[:name])
            venue.update({name: venue_params[:name],
                          zip: venue_params[:zip],
                          state: venue_params[:state],
                          phone: venue_params[:phone],
                          email: venue_params[:email],
                          city: venue_params[:city],
                          address: venue_params[:address],
                          contact: venue_params[:contact]})
            show.venue = venue
          else
            show.venue = Venue.create({name: venue_params[:name],
                                       zip: venue_params[:zip],
                                       state: venue_params[:state],
                                       phone: venue_params[:phone],
                                       email: venue_params[:email],
                                       city: venue_params[:city],
                                       address: venue_params[:address],
                                       contact: venue_params[:contact]})
          end
          show.save
          show.extend(ShowRepresenter)
        end

        desc 'Update a Show.'
        params do
          requires :id, type: Integer, desc: 'Show ID.'
          requires :sync_uuid, type: String, desc: 'Unique ID used to identify the object within API clients.'
          requires :date, type: DateTime, desc: 'Date of show.'
          requires :active, type: Boolean, desc: 'Active flag.'
          requires :deleted_state, type: Boolean, default: false, desc: 'Deleted state.'
          requires :road_merch_only, type: Boolean, desc: 'Road merch only status'
          optional :venue_cut, type: Integer, desc: 'Venue cut'
          optional :venue, type: Hash do
            requires :name, type: String, desc: 'Venue Name'
            requires :zip, type: Integer, desc: 'Venue Zip'
            requires :state, type: String, desc: 'Venue State'
            requires :phone, type: String, desc: 'Venue Phone'
            requires :email, type: String, desc: 'Venue Email'
            requires :city, type: String, desc: 'Venue City'
            requires :address, type: String, desc: 'Venue Address'
            requires :contact, type: String, desc: 'Venue contact'
          end
        end
        put ':id' do
          authenticate!
          show = current_user.shows.find(params[:id])
          show_params = {
              date: params[:date],
              sync_uuid: params[:sync_uuid],
              active: params[:active],
              deleted_state: params[:deleted_state],
              road_merch_only: params[:road_merch_only]
          }
          show_params['venue_cut'] = params['venue_cut'] if params['venue_cut']
          show.update(show_params)
          venue_params = params[:venue]
          if venue_params && venue = show.venue
            venue.update({name: venue_params[:name],
                          zip: venue_params[:zip],
                          state: venue_params[:state],
                          phone: venue_params[:phone],
                          email: venue_params[:email],
                          city: venue_params[:city],
                          address: venue_params[:address],
                          contact: venue_params[:contact]})
          end
          show.extend(ShowRepresenter)
        end

        desc 'Delete a Show.'
        params do
          requires :id, type: Integer, desc: 'Show ID.'
        end
        delete ':id' do
          status 204
          authenticate!
          current_user.shows.find(params[:id]).destroy.extend(ShowRepresenter)
        end

      end
    end
  end
end