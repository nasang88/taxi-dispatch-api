class DispatchesController < ApplicationController
  before_action :set_params, only: [:show, :update]

  # GET /dispatches
  def index
    @dispatches = Dispatch.all
    json_response(@dispatches)
  end

  # POST /dispatches
  def create
    @dispatch = Dispatch.create!(dispatch_params)
    json_response(@dispatch, :created)
  end

  # PATCH /dispatches/:id
  def update
    @dispatch.update(dispatch_params)
    if @dispatch.accepted_at.nil?
      json_response({}, :bad_request)
    else
      json_response(@dispatch)
    end
  end

  private

  def dispatch_params
    params.permit(:address, :driver_id, :passenger_id, :requested_at, :accepted_at)
  end

  def set_params
    @dispatch = Dispatch.find(params[:id])
  end

end
