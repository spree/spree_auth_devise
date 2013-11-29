require 'spec_helper'
require 'spree/testing_support/bar_ability'

describe Spree::Admin::UsersController do

  context '#authorize_admin' do
    let(:user) { create(:user) }
    let(:mock_user) { mock_model Spree::User }

    before do
      controller.stub :spree_current_user => user
      Spree::User.stub(:find).with(mock_user.id.to_s).and_return(mock_user)
      Spree::User.stub(:new).and_return(mock_user)
      user.spree_roles.clear
    end

    context "admin" do
      before { user.spree_roles << Spree::Role.find_or_create_by(name: 'admin') }

      it 'should grant access to users with an admin role' do
        spree_post :index
        response.should render_template :index
      end

      it "allows admins to update a user's API key" do
        mock_user.should_receive(:generate_spree_api_key!).and_return(true)
        spree_put :generate_api_key, :id => mock_user.id
        response.should redirect_to(spree.edit_admin_user_path(mock_user))
      end

      it "allows admins to clear a user's API key" do
        mock_user.should_receive(:clear_spree_api_key!).and_return(true)
        spree_put :clear_api_key, :id => mock_user.id
        response.should redirect_to(spree.edit_admin_user_path(mock_user))
      end
    end

    it 'should deny access to users with an bar role' do
      user.spree_roles << Spree::Role.find_or_create_by(name: 'bar')
      Spree::Ability.register_ability(BarAbility)
      spree_post :update, { :id => '9' }
      response.should redirect_to('/unauthorized')
    end

    it 'should deny access to users without an admin role' do
      user.stub :has_spree_role? => false
      spree_post :index
      response.should redirect_to('/unauthorized')
    end
  end
end
