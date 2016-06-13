require 'rails_helper'

RSpec.configure do |c|
  c.infer_base_class_for_anonymous_controllers = true
end

class ApplicationController < ActionController::Base; end

describe AdminController do
  controller do
    def index
      render :nothing => true
    end
  end

  describe "#ensure_admin" do
    context "not an user" do
      before { get :index }
      it "flashes danger" do
        expect(flash[:danger]).to be_present
      end

      it "redirects to home page" do
        expect(response).to redirect_to root_path
      end
    end

    context "is a user not admin" do
      let (:user1) { Fabricate(:user) }
      
      before do
        set_current_user(user1)
        get :index
      end
      
      it "redirects to user home page" do
        expect(response).to redirect_to root_path #user_path(user1)
      end

      it "sets the flash danger" do
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "#admin?" do
    let!(:user1) { Fabricate(:user) }
    context "user is admin" do
      before do
        set_admin_user(user1)
        get :index
      end
      
      it "returns true for admin user" do
        expect(controller.send(:admin?)).to be_truthy
      end
    end

    context "user is not admin" do
      before do
        set_current_user(user1)
        get :index
      end

      it "returns false for normal user" do
        expect(controller.send(:admin?)).to be_falsey
      end
    end
    
  end

end
