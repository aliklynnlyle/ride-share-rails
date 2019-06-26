class AdminRideController < ApplicationController

    before_action :authenticate_user!
    layout 'administration'
  
      def new
        @ride = Ride.new
      end
  
      def show
        @ride = Ride.find(params[:id])
        @start_location = Location.find(@ride.start_location_id)
        @end_location = Location.find(@ride.end_location_id)
      end
  
      def index
        @rides = Ride.all
      end
  
      def create
        @start_location = Location.new(
          street: ride_params[:start_street], 
          city: ride_params[:start_city],
          state: ride_params[:start_state],
          zip: ride_params[:start_zip])
        @start_location.save
        @start_location.reload
  
        @end_location = Location.new(
          street: ride_params[:end_street], 
          city: ride_params[:end_city],
          state: ride_params[:end_state],
          zip: ride_params[:end_zip])
        @end_location.save
        @end_location.reload
  
        @ride = Ride.new(
          organization_id: current_user.organization_id,
          rider_id: ride_params[:rider_id], 
          pick_up_time: ride_params[:pick_up_time],
          start_location_id: @start_location.id,
          end_location_id: @end_location.id,
          reason: ride_params[:reason],
          status: "requested")
  
        if @ride.save
          @ride.reload
          redirect_to admin_ride_path(@ride)
        else
          render 'new'
        end
      end
  
      def edit
        @ride = Ride.find(params[:id])
      end
  
      def update

        # @start_location = @ride.start_location
        # @start_location.save
        # @start_location.reload
  
        # @end_location = @ride.end_location
        # @end_location.save
        # @end_location.reload

        # @start_location.update()
        # @end_location.update()

  
        # @ride = Ride.new(
        #   organization_id: current_user.organization_id,
        #   rider_id: ride_params[:rider_id], 
        #   pick_up_time: ride_params[:pick_up_time],
        #   start_location_id: @start_location.id,
        #   end_location_id: @end_location.id,
        #   reason: ride_params[:reason],
        #   status: "requested")
  
        # if @ride.save
        #   @ride.reload
        #   redirect_to admin_ride_path(@ride)
        # else
        #   render 'new'
        # end

        # @ride = Ride.find(params[:id])
  
        # if @start_location.update(ride_params)
        #   redirect_to admin_ride_path(@ride)
        # else
        #   render 'edit'
        # end
    
        # if @end_location.update(ride_params)
        #   redirect_to admin_ride_path(@ride)
        # else
        #   render 'edit'
        # end

        # if @ride.update(ride_params)
        #    redirect_to admin_ride_path(@ride)
        # else
        #   render 'edit'
        # end
      end
  
      def destroy
        @ride = Ride.find(params[:id])
        @ride.destroy
  
        redirect_to admin_ride_index_path
      end
  
      private
      def ride_params
        params.require(:ride).permit(:rider_id, :driver_id, :pick_up_time, 
        :start_street, :start_city, :start_state, :start_zip, 
        :end_street, :end_city, :end_state, :end_zip, :reason, :status)
      end
  
  end
  
  
  