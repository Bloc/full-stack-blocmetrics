
class Api::V1::EventsController < Api::V1::BaseController

  def index
    render nothing: true
  end

  def create

    domain = current_user.domain_from_caller(request.referer)

    if domain.blank?
      render json: {status: "error"}, status: :forbidden
    else
      event = domain.events.build(name: params[:name], data: params[:data])
      event.save
      render json: {status: "ok"}, status: :created
    end

  end

  protected

  def event_params

  end
end
