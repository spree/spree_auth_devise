require 'spec_helper'
describe Spree::UserRegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:spree_user]
  end
  context '#create' do
    before { controller.stub(:after_sign_up_path_for).and_return(spree.root_path(thing: 7)) }
    it 'should redirect to after_sign_up_path_for' do
      spree_post :create, { :spree_user => { :email => 'foobar@example.com', :password => 'foobar123', :password_confirmation => 'foobar123' } }
      expect(response).to redirect_to spree.root_path(thing: 7)
    end
  end
end
