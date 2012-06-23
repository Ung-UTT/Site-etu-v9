require 'spec_helper'

describe ActivityObserver do
  it "triggers the observer when a new classified is created" do
    classified = create :classified
    last_activity = Activity.get(0)

    last_activity['what'].should == 'create'
    last_activity['model_id'].should == classified.id
  end
end

