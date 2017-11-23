require 'date'

class TravelPlanningController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  PER = 10

  def index
    @schedules = Schedule.page(params[:page]).per(PER).order('created_at')
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
      if @schedule.save!
        #スケジュール日付データを1日ずつ作成
        sche_each_date_create
        #うまくいけば、成功メッセージ
        flash[:success] = "スケジュールを作成しました"
      else
        sche_err_chk
      end
    end
    redirect_to root_path
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
      else
        sche_err_chk
      end
    end
    redirect_to root_path
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
    redirect_to root_path
  end

  private
   def sche_err_chk
     if @schedule.errors.messages.present?
       if @schedule.errors.messages[:title].present?
         flash[:error] = "タイトル" + @schedule.errors.messages[:title][0]
       end
         if @schedule.errors.messages[:from_date].present?
           flash[:error] = @schedule.errors.messages[:from_date][1]
         end
         if @schedule.errors.messages[:to_date].present?
           flash[:error] = @schedule.errors.messages[:to_date][1]
         end
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
       if !@schedule.schedule_each_dates.create!( user_id: 1, schedule_id: @schedule.id ,sche_date: start_date)
         #失敗すれば、エラーメッセージ
           flash[:error] = "スケジュールの作成または更新に失敗しました"
           redirect_to root_path
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
