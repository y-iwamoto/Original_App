class HomeController < ApplicationController
  def index
    #スポットで最新のデータを３件取得
    @newest_spots = Spot.select(:name,:place_id).order("created_at desc").limit(3).uniq

    @client = GooglePlaces::Client.new( ENV['GOOGLE_MAP_API_KEY'] )
    @newest_spots_ary = []
    spot_array(@newest_spots,@newest_spots_ary)

    #スポットでお気に入りに登録されたのデータを３件取得
    @favorite_spots = Spot.select(:name,:place_id).where("favorite_flg = ?", true).order("RANDOM()").limit(3).uniq
    @favorite_spots_ary = []
    spot_array(@favorite_spots,@favorite_spots_ary)
  end
  def SpotImg
    #画像のバイナリデータを取得
    @photo = HTTParty.get("https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{params[:photo_reference]}&key=#{ENV['GOOGLE_MAP_API_KEY']}")
    #画像データを送信
    send_data @photo, :type => 'image/png', :disposition => 'inline'
  end
  private
    def spot_array(spots,spots_ary)
      @spots_hash = {}
      #GooglePlaceからデータを取得し、表示用の配列に格納
      spots.each_with_index do |each_spot, i|
        @spot_details = @client.spot(each_spot.place_id , :language => 'ja' )
        @spots_hash.store("name"+i.to_s,@spot_details.name)
        @spots_hash.store("photo"+i.to_s,@spot_details.photos[0] == nil ? "" : @spot_details.photos[0].photo_reference)
        spots_ary.push(@spots_hash)
      end
      return spots_ary
    end

end
