class SpotSearchController < ApplicationController
  before_action :set_spot, only: [:show, :destroy, :select]
  def index
    @spots = Spot.all
  end

  def list
    keyword = params[:search]
    @client = GooglePlaces::Client.new( ENV['GOOGLE_API_KEY'] )
    @spots = @client.spots_by_query( keyword )
  end

  def show
  end

  def select
      render file: "/layouts/closed_and_reloaded", locals: {spot: @spot }, layout: false
  end

  def create
   @spot = Spot.new(spot_params)

   respond_to do |format|
     if @spot.save
       format.html { redirect_to spot_search_index_path, notice: "#{@spot.name} の位置情報を保存しました" }
     else
       format.html { render :index, notice: "#{@spot.name} の位置情報を保存できませんでした" }
     end
   end
 end

 def destroy
   @spot.destroy

   respond_to do |format|
     format.html { redirect_to spot_search_index_path, notice: "#{@spot.name} の位置情報を削除しました" }
   end
 end

  private
    def set_spot
      @spot = Spot.find(params[:id])
    end

    def spot_params
      params.require(:spot).permit(:name, :latitude, :longitude, :address)
    end
end
