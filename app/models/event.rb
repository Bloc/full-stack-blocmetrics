class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :domain

  field :name,              type: String
  field :data,              type: Hash

end
