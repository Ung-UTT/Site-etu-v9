require 'spec_helper'

describe ActivityObserver do
  before do
    # fake user since PaperTrail relies on `current_user' which is not defined here
    PaperTrail.whodunnit = 'RSpec'
  end

  it "triggers the observer when a new classified is created" do
    classified = create :classified

    last_activity = Activity.get(0)
    last_activity['what'].should == 'create'
    last_activity['model_id'].should == classified.id
  end
end

