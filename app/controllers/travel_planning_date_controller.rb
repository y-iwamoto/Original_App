require "date"
class TravelPlanningDateController < ApplicationController
  def index
    @schedule_id = params[:schedule_id]
    respond_to do |format|
      format.html
    end
  end
end
