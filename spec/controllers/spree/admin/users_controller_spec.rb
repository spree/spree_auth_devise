require 'spec_helper'

describe Spree::Admin::UsersController do

  context '#authorize_admin' do
    let(:user) { Spree::User.new }
    let(:mock_user) { mock_model Spree::User }

    before do
      controller.stub :spree_current_user => user
      Spree::User.stub(:find).with('9').and_return(mock_user)
      Spree::User.stub(:new).and_return(mock_user)
    end

    after(:each) { user.roles = [] }

    it 'should grant access to users with an admin role' do
      #user.stub :has_role? => true
      user.roles = [Spree::Role.find_or_create_by_name('admin')]
      post :index
      response.should render_template :index
    end

    it 'should deny access to users with an bar role' do
      user.roles = [Spree::Role.find_or_create_by_name('bar')]
      Spree::Ability.register_ability(BarAbility)
      post :index
      response.should render_template 'spree/shared/unauthorized'
    end

    it 'should deny access to users with an bar role' do
      user.roles = [Spree::Role.find_or_create_by_name('bar')]
      Spree::Ability.register_ability(BarAbility)
      post :update, { :id => '9' }
      response.should render_template 'spree/shared/unauthorized'
    end

    it 'should deny access to users without an admin role' do
      user.stub :has_role? => false
      post :index
      response.should render_template 'spree/shared/unauthorized'
    end
  end

  context "#index" do
    it "should not allow JSON request without a valid token" do
      controller.should_receive(:protect_against_forgery?).at_least(:once).and_return(true)
      expect {
        get :index, {:format => :json}
      }.to raise_error ActionController::InvalidAuthenticityToken
    end

    it "should allow JSON request with missing token if forgery protection is disabled" do
      controller.should_receive(:protect_against_forgery?).at_least(:once).and_return(false)
      get :index, {:format => :json}
      response.should be_success
    end

    it "should allow JSON request with invalid token if forgery protection is disabled" do
      controller.should_receive(:protect_against_forgery?).at_least(:once).and_return(false)
      get :index, {:authenticity_token => "XYZZY", :format => :json}
      response.should be_success
    end

    it "should allow JSON request with a valid token" do
      controller.should_receive(:protect_against_forgery?).at_least(:once).and_return(true)
      controller.stub :form_authenticity_token => "123456"
      get :index, {:authenticity_token => "123456", :format => :json}
      response.should be_success
    end

    it "should allow JSON request when token has URL(+,&,=) characters" do
      controller.should_receive(:protect_against_forgery?).at_least(:once).and_return(true)
      controller.stub :form_authenticity_token => "1+2=3&4'5/6?"
      get :index, {:authenticity_token => "1+2%3D3%264%275/6%3F", :format => :json}
      response.should be_success
    end

  end
end
