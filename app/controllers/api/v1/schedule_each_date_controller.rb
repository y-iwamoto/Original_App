require "#{Rails.root}/app/controllers/application_controller.rb"

module Api
  module V1
    class ScheduleEachDateController < ApplicationController

      def index
        schedule_id = params['custom_param1']
        @schedule_each_date = ScheduleEachDate.where(schedule_id: schedule_id).order(:id).limit(params[:limit]).offset(params[:offset])
        render 'index', formats: 'json', handlers: 'jbuilder'
      end

      def show
        @schedule_each_date = ScheduleEachDate.find(params[:id])
        render 'index', formats: 'json', handlers: 'jbuilder'
      end


      private
        # def event_params
        #   params[:event]
        #   .permit(
        #     :title,
        #     :start,
        #     :end,
        #     :color,
        #     :allday
        #   )
        # end

    end
  end
end
