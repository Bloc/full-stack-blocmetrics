class Api::V1::EventsController < Api::V1::BaseController

  def index
    render nothing: true
  end

  def create
    render json: {status: "ok"}, status: :created
  end

end
