require 'uri'
class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :authentication_token, type: String

  has_many :domains

  before_create :generate_authentication_token

  def domain_from_caller(referer)
    uri = URI.parse(referer)
    request_origin = "#{uri.scheme}://#{uri.host}"

    if uri.port != 80
      request_origin += ":#{uri.port}"
    end
    self.domains.where(url: request_origin).first
  end

  protected

  # Generate an authentication token for API access
  def generate_authentication_token
    self.authentication_token = SecureRandom.hex(32)
  end

end
