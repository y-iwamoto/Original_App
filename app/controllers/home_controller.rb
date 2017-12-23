class HomeController < ApplicationController
  def index
    #スポットで最新のデータを３件取得
    @newest_spots = Spot.select(:name,:place_id).order("created_at desc").limit(3).uniq

    @client = GooglePlaces::Client.new( ENV['GOOGLE_MAP_API_KEY'] )
    @newest_spots_ary = []
    @newest_spots_hash = {}
    i = 0
    #GooglePlaceからデータを取得し、表示用の配列に格納
    @newest_spots.each do |newest_spot|
      @spot_details = @client.spot( newest_spot.place_id , :language => 'ja' )
      @newest_spots_hash.store("name"+i.to_s,@spot_details.name)
      @newest_spots_hash.store("photo"+i.to_s,@spot_details.photos[0] == nil ? "" : @spot_details.photos[0].photo_reference)
      @newest_spots_ary.push(@newest_spots_hash)
      i = i+1
    end

    #スポットでお気に入りに登録されたのデータを３件取得
    @favorite_spots = Spot.select(:name,:place_id).where("favorite_flg = ?", true).order("RANDOM()").limit(3).uniq
    @favorite_spots_ary = []

    @favorite_spots_hash = {}
    i = 0
    #GooglePlaceからデータを取得し、表示用の配列に格納
    @favorite_spots.each do |favorite_spot|
      @fspot_details = @client.spot( favorite_spot.place_id , :language => 'ja' )
      @favorite_spots_hash.store("name"+i.to_s,@fspot_details.name)
      @favorite_spots_hash.store("photo"+i.to_s,@fspot_details.photos[0] == nil ? "" : @fspot_details.photos[0].photo_reference)
      @favorite_spots_ary.push(@favorite_spots_hash)
      i = i+1
    end
  end
  def getImg
    #画像のバイナリデータを取得
    @photo = HTTParty.get("https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{params[:photo_reference]}&key=#{ENV['GOOGLE_MAP_API_KEY']}")
    #画像データを送信
    send_data @photo, :type => 'image/png', :disposition => 'inline'
  end

end
