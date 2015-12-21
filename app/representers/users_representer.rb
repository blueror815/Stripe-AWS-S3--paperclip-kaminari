require 'roar/json'

module UsersRepresenter
  include Roar::JSON

  property :num_trial
  property :num_full
  collection :users, extend: UserRepresenter, class: User

end