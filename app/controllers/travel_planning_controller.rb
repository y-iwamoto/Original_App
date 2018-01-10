require 'date'

class TravelPlanningController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  PER = 10

  def index
    @schedules = Schedule.where(user_id: current_user.id).page(params[:page]).per(PER).order('created_at')
    #エラー表示用に生成
    @schedule = Schedule.new
  end

  def new
    @schedule = Schedule.new
    today = Date.today
    @schedule.from_date = today
    @schedule.to_date = today
  end

  def create
    @schedule = Schedule.new(schedule_params)
    # トランザクション開始
    ActiveRecord::Base.transaction do
      #スケジュールのバリデーションに引っかからなかった場合
      if @schedule.save
        #スケジュール日付データを1日ずつ作成
        sche_each_date_create
        #うまくいけば、成功メッセージ
        flash[:success] = "スケジュールを作成しました"
        redirect_to travel_planning_index_path
      #スケジュールのバリデーションに引っかかった場合
      else
        sche_err_chk("登録")
        #スケジュール一覧を表示させるため、検索
        @schedules = Schedule.where(user_id: current_user.id).page(params[:page]).per(PER).order('created_at')
      end
    end
  end

  def edit
  end

  def update
    # トランザクション開始
    ActiveRecord::Base.transaction do
      if @schedule.update(schedule_params)
        #スケジュールIDを元に、スケジュール日付一旦削除し、新規作成し直す
        ScheduleEachDate.where(schedule_id: @schedule.id).delete_all
        #スケジュール日付データを1日ずつ作成
        sche_each_date_create
        #うまくいけば、成功メッセージ
        flash[:success] = "スケジュールを更新しました"
        redirect_to travel_planning_index_path
      else
        sche_err_chk("更新")
        #スケジュール一覧を表示させるため、検索
        @schedules = Schedule.where(user_id: current_user.id).page(params[:page]).per(PER).order('created_at')
      end
    end
  end

  def destroy
    # トランザクション開始
    ActiveRecord::Base.transaction do
      #スケジュールIDを元に、スケジュール日付削除
      ScheduleEachDate.where(schedule_id: @schedule.id).delete_all
      if @schedule.destroy
        flash[:success] = "スケジュールを削除しました"
      else
        flash[:error] = "スケジュールの削除に失敗しました"
      end
    end
    redirect_to travel_planning_index_path
  end

  private
   def sche_err_chk(kbn)
     if @schedule.errors.messages.present?
         flash[:error] = "スケジュールが" + kbn + "できませんでした"
     end
   end

   def sche_each_date_create
     #日付のfrom,toから取得期間を生成
     from_date = @schedule.from_date
     to_date = @schedule.to_date
     travel_term = (to_date - from_date).to_i + 1
     start_date = from_date

     #初日からループで回し、１件ごとにデータ作成
     for i in 1..travel_term
       if !@schedule.schedule_each_dates.create!( user_id: current_user.id, schedule_id: @schedule.id ,sche_date: start_date)
         #失敗すれば、エラーメッセージ
           flash[:error] = "スケジュールの作成または更新に失敗しました"
           redirect_to travel_planning_index_path
       end
       start_date = start_date + 1
     end
   end

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:user_id,:from_date,:to_date,:title)
  end

end
