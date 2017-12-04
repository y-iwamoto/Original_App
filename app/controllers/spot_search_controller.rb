class SpotSearchController < ApplicationController
  before_action :set_spot, only: [:show, :destroy, :select,:favorite_create]
  def index
    #お気に入り登録時にユーザIDが必要のため、セッションに格納
    if params[:user_id].present?
      session[:user_id] = params[:user_id]
    end
    @spots = Spot.all
  end

  def list
    #キーワード検索を行う
    keyword = params[:search]
    @client = GooglePlaces::Client.new( ENV['GOOGLE_API_KEY'] )
    @spots = @client.spots_by_query( keyword , :language => 'ja' )
  end

  def show
  end

  def select
      #JSで立ち上げたウィンドウを閉じる
      render file: "/layouts/closed_and_reloaded", locals: {spot: @spot}, layout: false
  end

  def favorite_create
    #お気に入りスポットから対象スポットIDで検索
    @favorite_spot = FavoriteSpot.find_by(user_id: session[:user_id],spot_id: @spot.id)
    #検索結果があればdelete,なければcreate
    if @favorite_spot.present?
      @favorite_spot.destroy
      respond_to do |format|
        format.html { redirect_to spot_search_index_path, notice: "お気に入り情報から削除しました" }
      end
    else
      FavoriteSpot.create(user_id: session[:user_id],spot_id: @spot.id)
      respond_to do |format|
        format.html { redirect_to spot_search_index_path, notice: "お気に入り情報に登録しました" }
      end
    end
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
   #まずお気に入り情報を削除
   #お気に入りスポットから対象スポットIDで検索
   @favorite_spot = FavoriteSpot.find_by(user_id: session[:user_id],spot_id: @spot.id)
   #検索結果があればdelete,なければcreate
   if @favorite_spot.present?
     @favorite_spot.destroy
   end
   #次にスポット情報を削除
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
