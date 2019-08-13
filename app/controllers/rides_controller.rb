class RidesController < ApplicationController

  before_action :authenticate_rider!
  rescue_from Pundit::NotAuthorizedError, with: :rider_not_authorized

  layout 'rider_layout'

    def new
      @ride = Ride.new
    end

    def show
      @ride = Ride.find(params[:id])
      unless RidePolicy.new(current_rider, @ride).show?
          raise Pundit::NotAuthorizedError
      end
      @start_location = Location.find(@ride.start_location_id)
      @end_location = Location.find(@ride.end_location_id)
    end

    def index
      @rides = current_rider.rides
      @rides = Kaminari.paginate_array(@rides).page(params[:page]).per(10)
    end

    def create
      token = current_rider.next_valid_token
      unless token.nil?
        start_location = Location.new(
          street: ride_params[:start_street],
          city: ride_params[:start_city],
          state: ride_params[:start_state],
          zip: ride_params[:start_zip])

        end_location = Location.new(
          street: ride_params[:end_street],
          city: ride_params[:end_city],
          state: ride_params[:end_state],
          zip: ride_params[:end_zip])

        @ride = current_rider.rides.new(
          organization_id: current_rider.organization.id,
          pick_up_time: ride_params[:pick_up_time],
          start_location: start_location,
          end_location: end_location,
          reason: ride_params[:reason])
        @ride.status = "approved" if current_rider.organization.use_tokens?

        if @ride.save
          token.ride_id = @ride.id
          token.save
          flash[:notice] = "Ride created."
          redirect_to @ride
        else
          render 'new'
        end
      else
        flash[:notice] = "You do not have enough valid tokens to request this ride"
        redirect_to rides_path
      end
    end

    def edit
      @ride = Ride.find(params[:id])
      unless RidePolicy.new(current_rider, @ride).edit?
        raise Pundit::NotAuthorizedError
      end
    end

    def update
      @ride = Ride.find(params[:id])
      unless RidePolicy.new(current_rider, @ride).update?
        raise Pundit::NotAuthorizedError
      end

      @start_location = @ride.start_location
      @end_location = @ride.end_location

      if !@start_location.update(
        street: ride_params[:start_street],
        city: ride_params[:start_city],
        state: ride_params[:start_state],
        zip: ride_params[:start_zip])
        flash.now[:alert] = @start_location.errors.full_messages.join(", ")

        render 'edit' and return
      end

      if !@end_location.update(
        street: ride_params[:end_street],
        city: ride_params[:end_city],
        state: ride_params[:end_state],
        zip: ride_params[:end_zip])
        flash.now[:alert] = @end_location.errors.full_messages.join(", ")

        render 'edit' and return
      end

      if @ride.update(
        pick_up_time: ride_params[:pick_up_time],
        reason: ride_params[:reason])
        flash.notice = "The ride information has been updated"
        redirect_to ride_path(@ride)
      else
        render 'edit'
      end
    end

    private
    def ride_params
      params.require(:ride).permit(:rider_id, :driver_id, :pick_up_time,
      :start_street, :start_city, :start_state, :start_zip,
      :end_street, :end_city, :end_state, :end_zip, :reason, :status)
    end

    def rider_not_authorized
      flash.notice = "You are not authorized to view this information"

      redirect_to rides_path
    end
end
