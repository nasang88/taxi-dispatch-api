class DispatchesController < ApplicationController
  before_action :set_params, only: [:show, :update]

  # GET /dispatches
  def index
    @dispatches = Dispatch.all
    json_response(@dispatches)
  end

  # POST /dispatches
  def create
    @dispatch = Dispatch.create!(dispatch_request_params)
    json_response(@dispatch, :created)
  end

  # PATCH /dispatches/:id
  def update
    @dispatch.update(dispatch_accept_params)
    json_response(@dispatch)
  end

  private

  def dispatch_request_params
    params[:passenger_id] = current_user.id
    params.permit(:address, :passenger_id, :requested_at)
  end

  def dispatch_accept_params
    params[:driver_id] = current_user.id
    params.require(:accepted_at)
    params.permit(:driver_id, :accepted_at)
  end

  def set_params
    @dispatch = Dispatch.find(params[:id])
  end

end
