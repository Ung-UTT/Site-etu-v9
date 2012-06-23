class ActivityObserver < ActiveRecord::Observer
  # Add the models you want to observe for the activity feed here.
  # Those models must be versionned with PaperTrail.
  observe :annal, :answer, :asso, :assos_event, :carpool, :classified, :comment,
          :course, :document, :event, :events_user, :image, :news, :project,
          :quote, :role, :timesheet, :user, :wiki

  def after_save(model)
    version = model.versions.last

    who = version.whodunnit
    return if who.nil? # update made internally

    what = version.event

    if model.respond_to? :polymorphic? and model.polymorphic?
      # since we can't link to a polymorphic model, we link its parent
      what = model.class.name.downcase
      return unless model = model.parent
    end

    Activity.add(
      who: who,
      what: what,
      when: version.created_at,
      model_class: model.class.name,
      model_id: model.id
    )
  end
end
