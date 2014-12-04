class Domain
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_many :events
  
  field :name,              type: String
  field :url,               type: String
  field :verified,          type: Boolean, default: false
  field :verification_code, type: String

  before_create :generate_verification_code

  protected

  def generate_verification_code
    self.verification_code = SecureRandom.hex(20)
  end

end
