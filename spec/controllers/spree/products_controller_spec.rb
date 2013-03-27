require 'spec_helper'

describe Spree::ProductsController do
  let!(:product) { create(:product, :available_on => 1.year.from_now) }
  let!(:user) { Spree::User.create }

  it "allows admins to view non-active products" do
    controller.stub :before_save_new_order
    controller.stub :spree_current_user => user 
    user.stub :has_spree_role? => true
    spree_get :show, :id => product.to_param
    response.status.should == 200
  end

  it "cannot view non-active products" do
    controller.stub :before_save_new_order
    controller.stub :spree_current_user => user 
    user.stub :has_spree_role? => false
    spree_get :show, :id => product.to_param
    response.status.should == 404
  end
end
