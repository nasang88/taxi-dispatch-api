class DispatchesController < ApplicationController
  before_action :set_params, only: [:accept_dispatch, :cancel_dispatch ,:delete_dispatch]

  #
  # GET /dispatches
  def index
    @dispatches = Dispatch.all.order(:requested_at).reverse

    json_response(@dispatches)
  end

  #
  # GET /dispatches/request
  def show_dispatch_request
    if !passenger_user
      return json_response({}, :bad_request)
    end
    @dispatches = Dispatch.where(passenger_id: current_user.id).order(:requested_at).reverse
    json_response(@dispatches)
  end

  #
  # GET /dispatches/accept
  def show_dispatch_accept
    if passenger_user
      return json_response({}, :bad_request)
    end
    @dispatches = Dispatch.where(driver_id: current_user.id).order(:requested_at).reverse
    json_response(@dispatches)
  end

  #
  # POST /dispatches
  def create_dispatch
    if !passenger_user
      return json_response({}, :bad_request)
    end
    @dispatch = Dispatch.create!(dispatch_request_params)
    json_response(@dispatch, :created)
  end

  #
  # POST /dispatches/:id/accept
  def accept_dispatch
    if passenger_user
      return json_response({}, :bad_request)
    end

    unless @dispatch.unaccepted?
      raise ExceptionHandler::ConflictData
    end

    @dispatch.update(dispatch_accept_params)
    json_response(@dispatch)
  end

  #
  # POST  /dispatches/:id/cancel
  def cancel_dispatch
    if !is_mine(target_id: @dispatch.driver_id)
      return json_response({}, :bad_request)
    end

    @dispatch.update(dispatch_cancel_params)
    json_response(@dispatch)
  end

  #
  # DELETE  /dispatches/:id
  def delete_dispatch
    if !is_mine(target_id: @dispatch.passenger_id)
      return json_response({}, :bad_request)
    end

    if is_accepted_request
      return json_response({}, :conflict)
    end

    @dispatch.destroy
    json_response({})
  end

  private

  def passenger_user
    current_user.user_type == 'passenger'
  end

  def is_accepted_request
    @dispatch.driver_id || @dispatch.accepted_at
  end

  def is_mine(target_id:)
    current_user.id == target_id
  end

  def dispatch_request_params
    params.permit(:address, :passenger_id, :requested_at).merge(passenger_id: current_user[:id])
  end

  def dispatch_accept_params
    params.require(:accepted_at)
    params.permit(:driver_id, :accepted_at).merge(driver_id: current_user[:id])
  end

  def dispatch_cancel_params
    params[:driver_id] = nil
    params[:accepted_at] = nil
    params.permit(:driver_id, :accepted_at)
  end

  def set_params
    @dispatch = Dispatch.find(params[:id])
  end

end
