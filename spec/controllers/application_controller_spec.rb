require 'spec_helper'

describe ApplicationController do
  describe "#catch_exceptions" do
    render_views

    controller do
      def index
        raise "wtf"
      end
    end

    it "notifies admins when an unexpected error occurs" do
      expect {
        get :index
      }.to change { UserMailer.deliveries.count }.by(1)
    end
  end
end

