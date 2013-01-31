require 'spec_helper'
require 'spree/core/testing_support/bar_ability'
require 'cancan'

describe Spree::Admin::OrdersController do

  let(:order) { stub_model(Spree::Order, :number => 'R123', :reload => nil, :save! => true) }
  before do
    Spree::Order.stub :find_by_number! => order
    #ensure no respond_overrides are in effect
    if Spree::BaseController.spree_responders[:OrdersController].present?
      Spree::BaseController.spree_responders[:OrdersController].clear
    end
  end

  context '#authorize_admin' do
    let(:user) { create(:user) }

    before do
      controller.stub :spree_current_user => user
      Spree::Order.stub(:new).and_return(order)
    end

    it 'should grant access to users with an admin role' do
      user.spree_roles << Spree::Role.find_or_create_by_name('admin')
      spree_post :index
      response.should render_template :index
    end

    it 'should grant access to users with an bar role' do
      user.spree_roles << Spree::Role.find_or_create_by_name('bar')
      Spree::Ability.register_ability(BarAbility)
      spree_post :index
      response.should render_template :index
    end

    it 'should deny access to users with an bar role' do
      order.stub(:update_attributes).and_return true
      order.stub(:user).and_return Spree::User.new
      order.stub(:token).and_return nil
      user.spree_roles.clear
      user.spree_roles << Spree::Role.find_or_create_by_name('bar')
      Spree::Ability.register_ability(BarAbility)
      spree_put :update, { :id => 'R123' }
      response.should redirect_to('/unauthorized')
    end

    it 'should deny access to users without an admin role' do
      user.stub :has_spree_role? => false
      spree_post :index
      response.should redirect_to('/unauthorized')
    end
  end
end
