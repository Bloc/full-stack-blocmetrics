class Api::V1::BaseController < ApplicationController

  respond_to :json, :xml

  skip_before_filter :verify_authenticity_token

  before_filter :authenticate_from_user_token!

  before_filter :cors_preflight_check
  after_filter :set_headers

  def authenticate_from_user_token!

    if request.method != "OPTIONS"
      token = params[:auth_token]
      user = User.where(authentication_token: token).first

      if user
        sign_in user, store: false
      else
        render json: {error: "Unauthorized"},status: :unauthorized and return
      end
    end
  end

  private

  # Allows resources to be shared across domains -- cross-origin resource sharing
  def set_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, GET, OPTIONS"
    headers['Access-Control-Allow-Headers'] = "Access-Control-Allow-Origin, Content-Type"
  end

  # A CORS preflight check allows poorly designd and legacy servers to support CORS by executing a sanity check
  # between client and server
  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Access-Control-Allow-Origin, X-Requested-With, X-Prototype-Version, Content-Type'
    headers['Access-Control-Max-Age'] = '1728000'
  end

end
