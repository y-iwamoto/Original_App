class TravelPlanningController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  PER = 10

  def index
    @schedules = Schedule.page(params[:page]).per(PER)
  end

  def new
    @schedule = Schedule.new
    require 'date'
    Date.today
    @schedule.from_date = Date.today
    @schedule.to_date = Date.today
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      flash[:success] = "スケジュールを作成しました"
    else
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
    @schedules = Schedule.page(params[:page]).per(PER)
    redirect_to root_path
  end

  def edit
  end

  def update
    if @schedule.update(schedule_params)
      flash[:success] = "スケジュールを更新しました"
    else
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
    @schedules = Schedule.all
    redirect_to root_path
  end

  def destroy
    if @schedule.destroy
      flash[:success] = "スケジュールを削除しました"
    else
      flash[:error] = "スケジュールの削除に失敗しました"
    end
    redirect_to root_path
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end
    def schedule_params
      params.require(:schedule).permit(:user_id,:from_date,:to_date,:title)
    end

end
