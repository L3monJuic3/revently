class ReservationsController < ApplicationController
  def user_bookings
    @reservations = Reservation.where(user_id: current_user)
    @current_bookings = (@reservations.where(booking: [Date.today..Date.today + 1000.days])).ordered
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @restaurant = Restaurant.find(params[:restaurant_id])
    @reservation.restaurant = @restaurant
    @reservation.user = current_user
    if @reservation.save!
      redirect_to user_bookings_path
    else
      render "restaurants/show", status: :unprocessable_entity
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to user_path, status: :see_other
  end

  private

  def reservation_params
    params.require(:reservation).permit(:booking)
  end
end
