class ActivitiesController < ApplicationController
  MAX_ACTIVITIES = 20

  # Display the last 20 activities that the current user can read
  def show
    @activities = []
    index = 0

    while activity = Activity.get(index) and @activities.size < MAX_ACTIVITIES
      index += 1
      model = activity['model_class'].constantize

      begin
        activity['resource'] = model.find(activity['model_id'])
      rescue ActiveRecord::RecordNotFound
        next # don't show deleted resources
      end

      if current_ability.can?(:read, activity['resource'])
        activity['user'] = UserDecorator.find(activity['who'])

        @activities << OpenStruct.new(activity)
      end
    end

    @activities = ActivityDecorator.decorate(@activities)

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end
end
