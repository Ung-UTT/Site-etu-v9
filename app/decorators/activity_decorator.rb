class ActivityDecorator < ApplicationDecorator
  decorates :activity

  def event
    [
      rss? ? activity.user.to_s : activity.user.link,
      h.t('activities.actions.' << activity.what),
      link,
      rss? ? '' : relative_when
    ].join(' ')
  end

  def link
    if activity.user == activity.resource
      h.t('activities.his_profile')
    else
      h.link_to(activity.resource, activity.resource)
    end
  end

  def relative_when
    h.t('activities.when', date: h.time_ago_in_words(activity.when))
  end

private

  def rss?
    h.params[:format] == 'rss'
  end
end
