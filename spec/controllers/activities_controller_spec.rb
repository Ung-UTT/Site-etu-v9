require 'spec_helper'

describe ActivitiesController do
  describe "#show" do
    render_views

    it "does not crash when no activities" do
      Activity.flush!

      get :show
      response.should be_success
    end

    it "returns the last #{ActivitiesController::MAX_ACTIVITIES} activities" do
      PaperTrail.whodunnit = create(:user).id # user for 'whodunnit'

      N = ActivitiesController::MAX_ACTIVITIES
      N.times do |n|
        create :classified, title: "Classfied #{n}"
      end

      get :show
      response.body.should include "Classfied 0"
      response.body.should include "Classfied #{N-1}"
      response.body.should_not include "Classfied #{N}"
    end

    it "does not include resources I cannot read" do
      annal = create :annal

      get :show
      response.body.should_not include annal.to_s
    end
  end
end
