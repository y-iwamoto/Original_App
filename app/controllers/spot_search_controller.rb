class SpotSearchController < ApplicationController
  before_action :set_spot, only: [:show, :destroy, :select,:favorite_create]
  PAGEING_NUM = 10
  def index
    #時間帯別の場所名を選択するリンクから来た場合は、選択ボタンを表示させるが、
    #ヘッダーから遷移して来た場合は表示させない
    if params[:select_link_disp].present?
      params[:select_link_disp] == "true" ? params[:select_link_disp] = true : params[:select_link_disp] = false
      session[:select_link_disp] = params[:select_link_disp]
    end
    @spots = Spot.where(user_id: current_user.id)
  end

  def list
    #キーワード検索を行う
    keyword = params[:search]
    @client = GooglePlaces::Client.new( ENV['GOOGLE_MAP_API_KEY'] )
    @spots = @client.spots_by_query( keyword , :language => 'ja' )

  end

  def show
    @client = GooglePlaces::Client.new( ENV['GOOGLE_MAP_API_KEY'] )
    @spot_details = @client.spot( @spot.place_id , :language => 'ja' )
    #スポットの住所で”国名、”より前が不要なので取り除いた住所を取得
    /、/ =~ @spot_details.formatted_address
    @formatted_address = $'
    #もし街灯がなければ、Placeで取得した住所をそのまま表示
    if @formatted_address == nil
      @formatted_address = @spot_details.formatted_address
    end
    #プレイスから所得できたフォトデータを最大10件まで配列に格納
    @arr = Array.new
    i = 0
    @spot_details.photos.each do |photo|
        @arr.push(photo.photo_reference)
        i = i + 1
        break if i == 10
    end
    #地図にマーカーを表示させるhash
    @hash = Gmaps4rails.build_markers(@spot) do |spot, marker|
      marker.lat spot.latitude
      marker.lng spot.longitude
      marker.infowindow spot.name
    end
    respond_to do |format|
      format.html
    end
  end

def favorite_spot_list
  @client = GooglePlaces::Client.new( ENV['GOOGLE_MAP_API_KEY'] )
  #スポットで対象ユーザでお気に入りに登録されたのデータを取得
  @favorite_spots = Spot.select(:name,:place_id).where("favorite_flg = ? and user_id = ?", true, current_user.id).order("created_at").uniq
  favorite_spots_ary = []
  @photos_ary = []
  favorite_spots_hash = {}
  i = 1
  #GooglePlaceからデータを取得し、表示用の配列に格納
  @favorite_spots.each do |favorite_spot|
    @fspot_details = @client.spot( favorite_spot.place_id , :language => 'ja' )
    favorite_spots_hash.store("name"+i.to_s,@fspot_details.name)
    favorite_spots_hash.store("address"+i.to_s,@fspot_details.formatted_address)
    favorite_spots_hash.store("photo"+i.to_s,@fspot_details.photos[0] == nil ? "" : @fspot_details.photos[0].photo_reference)
    favorite_spots_ary.push(favorite_spots_hash)
    i = i+1
  end
  @favorite_spots_ary = Kaminari.paginate_array(favorite_spots_ary).page(params[:page]).per(PAGEING_NUM)
  @pageing_num = PAGEING_NUM
end
  def getImg
    #画像のバイナリデータを取得
    @photo = HTTParty.get("https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{params[:photo_reference]}&key=#{ENV['GOOGLE_MAP_API_KEY']}")
    #画像データを送信
    send_data @photo, :type => 'image/png', :disposition => 'inline'
  end

  def select
      #JSで立ち上げたウィンドウを閉じる
      render file: "/layouts/closed_and_reloaded", locals: {spot: @spot}, layout: false
  end

  def favorite_create
    #お気に入りフラグをtrueでセット
    change_favorite_flg = true
    #すでにお気に入りフラグが立って入れば、falseにする
    if @spot.favorite_flg == true
      change_favorite_flg = false
    end
    #スポットを更新する
    if @spot.update_attribute(:favorite_flg, change_favorite_flg)
      notice = "お気に入りに追加しました"
      if change_favorite_flg == false
        notice = "お気に入りから解除しました"
      end
      respond_to do |format|
        format.html { redirect_to spot_search_index_path, notice: notice }
      end
    else
      respond_to do |format|
        format.html { redirect_to spot_search_index_path, notice: "お気に入り追加に失敗しました" }
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
      params.require(:spot).permit(:name, :latitude, :longitude, :address,:place_id,:user_id,:favorite_flg)
    end
end
