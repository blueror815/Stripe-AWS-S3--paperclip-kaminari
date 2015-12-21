require 'roar/json/hal'

module ApiKeyRepresenter
  include Roar::JSON::HAL

  property :id
  property :access_token, as: :token
  property :errors
  property :user, extend: UserRepresenter, class: User

end