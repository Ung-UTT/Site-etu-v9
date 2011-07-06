class CalendarController < ApplicationController
  def index
    authorize! :read, Event
  end
end
